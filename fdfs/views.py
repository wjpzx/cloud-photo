import hashlib
import json
import os
import random

from django.conf import settings
from django.http import HttpResponse, JsonResponse, FileResponse, Http404
import logging

from django.shortcuts import render, redirect
from django.views.decorators.http import require_http_methods

logger = logging.getLogger('fdfs')
from django.views.generic.base import View

from utils import redis
from utils.fdfs import fastdfs_server
from fdfs.models import File, User, Status
from utils.redis import get_user_id_by_session_id, check_sms_rate_limit, check_sms_daily_limit, check_sms_ip_limit
from utils.wrapper import login_require
from utils.yunpian import yunpian


# Create your views here.
class LoginView(View):
    def get(self, request):
        return render(request, 'login.html')

    def post(self, request):
        category = request.POST.get("category")
        phone = request.POST.get("phone")
        if category == "pass_login":
            passwd = request.POST.get("passwd")
            try:
                user = User.objects.get(phone=phone)
                md5_passwd = hashlib.md5(passwd.encode()).hexdigest()
                if user.passwd != md5_passwd:
                    return JsonResponse(data={'status': Status.error.value, 'message': "密码错误，请重试！"})
                else:
                    session_id = redis.set_session_id(phone, user.id)
                    response = JsonResponse(data={'status': Status.success.value, 'message': "登录成功"})
                    response.set_cookie("session_id", session_id)
                    return response

            except User.DoesNotExist:
                return JsonResponse(data={'status': Status.error.value, 'message': "未找到手机号请先注册"})
            except Exception as e:
                print(e, type(e))
                return JsonResponse(data={'status': Status.error.value, 'message': "登录失败，请确认信息后重试！"})
        elif category == "ver_phone":
            code = request.POST.get("code")
            user = User.objects.filter(phone=phone).first()
            redis_code = redis.get_code_phone(phone)
            if redis_code is None:
                return JsonResponse(data={'status': Status.error.value, "message": "验证码已过期，请重新获取"})
            redis_code = redis_code.decode()
            if redis_code == code:
                if not user:
                    user = User()
                    user.phone = phone
                    user.passwd = hashlib.md5("123456".encode()).hexdigest()
                    user.save()
                session_id = redis.set_session_id(phone, user.id)
                response = JsonResponse(data={'status': Status.success.value, 'message': "登录成功"})
                response.set_cookie("session_id", session_id)
                return response
            else:
                return JsonResponse(data={'status': Status.error.value, "message": "验证码错误，请稍后重试"})
        else:
            return JsonResponse(data={'status': Status.error.value, 'message': "操作失败，请稍后重试"})


@require_http_methods(["POST"])
def send_verification_code(request):
    phone = request.POST.get("phone")
    if not phone:
        return JsonResponse(data={"status": Status.error.value, 'message': "请输入手机号"})

    # Rate limit checks
    client_ip = request.META.get('HTTP_X_FORWARDED_FOR', request.META.get('REMOTE_ADDR', ''))
    if client_ip and ',' in client_ip:
        client_ip = client_ip.split(',')[0].strip()

    if not check_sms_rate_limit(phone):
        return JsonResponse(data={"status": Status.error.value, 'message': "发送过于频繁，请60秒后再试"})
    if not check_sms_daily_limit(phone):
        return JsonResponse(data={"status": Status.error.value, 'message': "今日发送次数已达上限"})
    if not check_sms_ip_limit(client_ip):
        return JsonResponse(data={"status": Status.error.value, 'message': "该IP发送次数过多，请稍后再试"})

    code = "%06d" % random.randint(0, 999999)

    if settings.DEBUG:
        redis.set_code_phone(phone, code)
        logger.info("验证码发送 - 手机号: %s, 验证码: %s" % (phone, code))
        return JsonResponse(data={"status": Status.success.value, 'message': "短信发送成功，请注意查收！"})
    else:
        result = yunpian.send_sms(phone)
        if result['code'] == 0:
            return JsonResponse(data={"status": Status.success.value, 'message': "短信发送成功，请注意查收！"})
        else:
            return JsonResponse(data={"status": Status.error.value, 'message': "发送失败，请稍后重试"})


def set_pass(request):
    category = request.POST.get("category")
    if category == "set_pass":
        # 进入设置密码范围
        phone = request.POST.get("phone")
        passwd = request.POST.get("passwd")
        try:
            user = User.objects.get(phone=phone)
            user.passwd = hashlib.md5(passwd.encode()).hexdigest()
            user.save()
            return JsonResponse(data={"status": Status.success.value, "message": "密码设置成功"})
        except User.DoesNotExist:
            return JsonResponse(data={"status": Status.error.value, "message": "手机号错误，请返回重试"})


@require_http_methods(["POST"])
def reset_password(request):
    phone = request.POST.get("phone")
    code = request.POST.get("code")
    passwd = request.POST.get("passwd")

    if not phone or not code or not passwd:
        return JsonResponse(data={'status': Status.error.value, 'message': "参数不完整"})

    redis_code = redis.get_code_phone(phone)
    if redis_code is None:
        return JsonResponse(data={'status': Status.error.value, 'message': "验证码已过期，请重新获取"})

    if redis_code.decode() != code:
        return JsonResponse(data={'status': Status.error.value, 'message': "验证码错误"})

    try:
        user = User.objects.get(phone=phone)
        user.passwd = hashlib.md5(passwd.encode()).hexdigest()
        user.save()
        return JsonResponse(data={'status': Status.success.value, 'message': "密码重置成功"})
    except User.DoesNotExist:
        return JsonResponse(data={'status': Status.error.value, 'message': "该手机号未注册"})


def logout(request):
    response = redirect('/fdfs/login/')
    response.delete_cookie("session_id")
    return response


@login_require
def index(request):
    session_id = request.COOKIES.get("session_id")
    user_id = get_user_id_by_session_id(session_id)
    files = File.objects.filter(user_id=user_id, is_deleted=False)
    if files:
        for file in files:
            file.url = settings.FASTDFS_FILE_PATH.get(file.file_id.split('/M00/')[0])['url_format'].format(
                file.file_id.split('/M00/')[1])

        data = files
        context = {
            'data': data,
            'request': request,
        }
    else:
        context = {'request': request}
    return render(request, 'pic.html', context=context)


@login_require
def create(request):
    session_id = request.COOKIES.get("session_id")
    user_id = get_user_id_by_session_id(session_id)
    old_files = request.FILES.getlist("file")
    if old_files:
        try:
            for old_file in old_files:
                content = []
                for line in old_file.chunks():
                    content.append(line)
                content = b''.join(content)

                result = fastdfs_server.upload_file(content, old_file.name.split('.')[-1])
                file_id = result['Remote file_id'].decode()
                size = result['Uploaded size']
                status = result['Status']
                if status == 'Upload successed.':
                    file = File()
                    file.user_id = user_id
                    file.name = old_file.name
                    file.file_id = file_id
                    file.size = size
                    file.save()
        except Exception as e:
            print("file_upload_error", e)
            return JsonResponse(data={"status": Status.error.value, "message": "上传错误，请稍后重试"})

        return JsonResponse(data={"status": Status.success.value, "message": "上传成功"})
    else:
        return JsonResponse(data={"status": Status.error.value, "message": "上传错误，请稍后重试"})


@login_require
def delete(request):
    """软删除 — 移入回收站，30天后彻底清除"""
    p_id = int(request.POST.get("id"))
    if p_id:
        try:
            from datetime import datetime
            f = File.objects.get(id=p_id)
            f.is_deleted = True
            f.deleted_at = datetime.now()
            f.save()
            return JsonResponse(data={"status": Status.success.value, "message": "已移入回收站，30天内可恢复"})
        except File.DoesNotExist:
            return JsonResponse(data={"status": Status.error.value, "message": "文件不存在"})
        except Exception as e:
            logger.error("删除文件出错: %s", e)
            return JsonResponse(data={"status": Status.error.value, "message": "操作失败，请稍后重试"})
    else:
        return JsonResponse(data={"status": Status.error.value, "message": "id错误，请稍后重试"})


@login_require
def recycle_bin(request):
    """回收站 — 查看已删除文件"""
    session_id = request.COOKIES.get("session_id")
    user_id = get_user_id_by_session_id(session_id)
    files = File.objects.filter(user_id=user_id, is_deleted=True).order_by('-deleted_at')
    from datetime import datetime, timedelta
    now = datetime.now()
    for f in files:
        f.url = settings.FASTDFS_FILE_PATH.get(f.file_id.split('/M00/')[0])['url_format'].format(
            f.file_id.split('/M00/')[1])
        if f.deleted_at:
            days_left = 30 - (now - f.deleted_at.replace(tzinfo=None)).days
            f.days_left = max(days_left, 0)
        else:
            f.days_left = 30
    return render(request, 'recycle_bin.html', {'files': files, 'request': request})


@login_require
def restore_file(request):
    """从回收站恢复文件"""
    p_id = int(request.POST.get("id"))
    if p_id:
        try:
            f = File.objects.get(id=p_id, is_deleted=True)
            f.is_deleted = False
            f.deleted_at = None
            f.save()
            return JsonResponse(data={"status": Status.success.value, "message": "已恢复"})
        except File.DoesNotExist:
            return JsonResponse(data={"status": Status.error.value, "message": "文件不存在"})
    return JsonResponse(data={"status": Status.error.value, "message": "id错误"})


@login_require
def permanent_delete(request):
    """彻底删除 — 从数据库和 FastDFS 同时删除"""
    p_id = int(request.POST.get("id"))
    if p_id:
        try:
            f = File.objects.get(id=p_id)
            remote_file_id = f.file_id
            # 从 FastDFS 删除
            try:
                fastdfs_server.delete_file(remote_file_id)
            except Exception as e:
                logger.warning("FastDFS 删除文件失败（可能不存在）: %s, error: %s", remote_file_id, e)
            # 从数据库删除
            f.delete()
            return JsonResponse(data={"status": Status.success.value, "message": "已彻底删除"})
        except File.DoesNotExist:
            return JsonResponse(data={"status": Status.error.value, "message": "文件不存在"})
    return JsonResponse(data={"status": Status.error.value, "message": "id错误"})


@login_require
def move_pic(request):
    if request.method == "POST":
        photo_id = request.POST.get("photo_id")
        folder_id = request.POST.get("folder_id")
        print("Move photo", photo_id, "to folder", folder_id)
        return JsonResponse({'message': '照片已移动'})
    return JsonResponse({'message': '请求无效'}, status=400)


@login_require
def serve_file(request, path):
    """登录后才能访问的图片文件 — 直接从云端 FastDFS 下载到内存返回"""
    remote_file_id = 'group1/M00/' + path
    try:
        result = fastdfs_server.client.download_to_buffer(remote_file_id.encode())
        content = result['Content']
    except Exception as e:
        logger.error("从云端下载文件失败: %s, error: %s" % (remote_file_id, e))
        raise Http404("文件不存在或云端不可达")
    
    content_types = {
        '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg',
        '.png': 'image/png', '.gif': 'image/gif',
        '.mp4': 'video/mp4', '.webp': 'image/webp',
    }
    ext = os.path.splitext(path)[1].lower()
    content_type = content_types.get(ext, 'application/octet-stream')
    return HttpResponse(content, content_type=content_type)
