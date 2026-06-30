import hashlib
import json
import os
import random

from django.conf import settings
from django.http import HttpResponse, JsonResponse, FileResponse, Http404
import logging

from django.shortcuts import render, redirect
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods

logger = logging.getLogger('fdfs')
from django.views.generic.base import View

# 全角→半角字符归一化
def _normalize(s):
    """全角数字/字母/符号转半角"""
    if not s:
        return s
    result = []
    for c in s:
        code = ord(c)
        if 0xFF01 <= code <= 0xFF5E:
            result.append(chr(code - 0xFEE0))
        elif code == 0x3000:  # 全角空格
            result.append(' ')
        else:
            result.append(c)
    return ''.join(result)

from utils import redis
from utils.fdfs import fastdfs_server
from fdfs.models import File, User, Status, Folder, Share
from utils.redis import get_user_id_by_session_id, check_sms_rate_limit, check_sms_daily_limit, check_sms_ip_limit
from utils.wrapper import login_require
from utils.yunpian import yunpian


# Create your views here.
class LoginView(View):
    def get(self, request):
        return render(request, 'login.html')

    def post(self, request):
        category = request.POST.get("category")
        phone = _normalize((request.POST.get("phone") or "").strip())
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
                    response.set_cookie("session_id", session_id, max_age=3600)
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
                response.set_cookie("session_id", session_id, max_age=3600)
                return response
            else:
                return JsonResponse(data={'status': Status.error.value, "message": "验证码错误，请稍后重试"})
        else:
            return JsonResponse(data={'status': Status.error.value, 'message': "操作失败，请稍后重试"})


@require_http_methods(["POST"])
def send_verification_code(request):
    phone = _normalize(request.POST.get("phone", ""))
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
        phone = _normalize((request.POST.get("phone") or "").strip())
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
    phone = _normalize((request.POST.get("phone") or "").strip())
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
    
    # 当前文件夹 ID（0=根目录）
    folder_id = request.GET.get("folder_id", "0")
    if folder_id != "0":
        try:
            current_folder = Folder.objects.get(id=int(folder_id), user_id=user_id, is_deleted=False)
            files = File.objects.filter(user_id=user_id, folder=current_folder, is_deleted=False)
            sub_folders = Folder.objects.filter(user_id=user_id, parent=current_folder, is_deleted=False)
        except Folder.DoesNotExist:
            files = File.objects.filter(user_id=user_id, folder__isnull=True, is_deleted=False)
            sub_folders = Folder.objects.filter(user_id=user_id, parent__isnull=True, is_deleted=False)
            folder_id = "0"
            current_folder = None
    else:
        files = File.objects.filter(user_id=user_id, folder__isnull=True, is_deleted=False)
        sub_folders = Folder.objects.filter(user_id=user_id, parent__isnull=True, is_deleted=False)
        current_folder = None
    
    # 构建面包屑路径（从根到当前文件夹）
    breadcrumbs = [{'id': 0, 'name': '根目录'}]
    if current_folder:
        ancestors = []
        f = current_folder
        while f:
            ancestors.insert(0, f)
            f = f.parent
        for a in ancestors:
            breadcrumbs.append({'id': a.id, 'name': a.name})
    
    if files:
        for file in files:
            file.url = settings.FASTDFS_FILE_PATH.get(file.file_id.split('/M00/')[0])['url_format'].format(
                file.file_id.split('/M00/')[1])
        data = files
    else:
        data = None
    
    context = {
        'data': data,
        'folders': sub_folders,
        'current_folder': current_folder,
        'folder_id': folder_id,
        'breadcrumbs': breadcrumbs,
        'request': request,
    }
    return render(request, 'pic.html', context=context)


@login_require
def create(request):
    session_id = request.COOKIES.get("session_id")
    user_id = get_user_id_by_session_id(session_id)
    folder_id = request.POST.get("folder_id", "").strip()
    old_files = request.FILES.getlist("file")
    if old_files:
        try:
            folder = None
            if folder_id and folder_id != "0":
                folder = Folder.objects.get(id=int(folder_id), user_id=user_id)
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
                    file.folder = folder
                    file.name = old_file.name
                    file.file_id = file_id
                    file.size = size
                    file.save()
        except Folder.DoesNotExist:
            return JsonResponse(data={"status": Status.error.value, "message": "文件夹不存在"})
        except Exception as e:
            logger.error("file_upload_error: %s", e)
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
    """回收站 — 只显示顶层已删除项"""
    session_id = request.COOKIES.get("session_id")
    user_id = get_user_id_by_session_id(session_id)
    from datetime import datetime, timedelta
    now = datetime.now()
    
    # 顶层文件夹：已删除且没有已删除的上级
    deleted_ids = set(Folder.objects.filter(user_id=user_id, is_deleted=True).values_list('id', flat=True))
    all_deleted_folders = Folder.objects.filter(user_id=user_id, is_deleted=True)
    top_folders = [f for f in all_deleted_folders if f.parent_id not in deleted_ids]
    
    # 顶层文件：已删除且所在文件夹未删除（或无文件夹）
    top_files = File.objects.filter(
        user_id=user_id, is_deleted=True
    ).exclude(
        folder_id__in=deleted_ids
    )
    
    # 构建路径和剩余天数
    for f in top_folders:
        f.days_left = 30
        if f.deleted_at:
            f.days_left = max(30 - (now - f.deleted_at.replace(tzinfo=None)).days, 0)
        f.full_path = _build_path(f)
    
    for f in top_files:
        f.url = settings.FASTDFS_FILE_PATH.get(f.file_id.split('/M00/')[0])['url_format'].format(
            f.file_id.split('/M00/')[1])
        f.days_left = 30
        if f.deleted_at:
            f.days_left = max(30 - (now - f.deleted_at.replace(tzinfo=None)).days, 0)
        f.full_path = _build_path(f.folder) if f.folder else ''
    
    return render(request, 'recycle_bin.html', {
        'folders': top_folders,
        'files': top_files,
        'request': request,
    })


def _build_path(folder):
    """构建文件夹完整路径"""
    if not folder:
        return ''
    parts = []
    f = folder
    while f:
        parts.insert(0, f.name)
        f = f.parent
    return '/'.join(parts)


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
def get_folder_contents(request):
    """AJAX 获取文件夹内容（子文件夹+文件）"""
    session_id = request.COOKIES.get("session_id")
    user_id = get_user_id_by_session_id(session_id)
    folder_id = request.GET.get("folder_id", "0").strip()
    if folder_id != "0":
        try:
            folder = Folder.objects.get(id=int(folder_id), user_id=user_id, is_deleted=False)
        except Folder.DoesNotExist:
            return JsonResponse(data={"status": Status.error.value, "message": "文件夹不存在"})
        sub_folders = Folder.objects.filter(user_id=user_id, parent=folder, is_deleted=False)
        files = File.objects.filter(user_id=user_id, folder=folder, is_deleted=False)
    else:
        folder = None
        sub_folders = Folder.objects.filter(user_id=user_id, parent__isnull=True, is_deleted=False)
        files = File.objects.filter(user_id=user_id, folder__isnull=True, is_deleted=False)
    
    folders_data = [{'id': f.id, 'name': f.name} for f in sub_folders]
    files_data = []
    for f in files:
        url = settings.FASTDFS_FILE_PATH.get(f.file_id.split('/M00/')[0])['url_format'].format(
            f.file_id.split('/M00/')[1])
        files_data.append({'id': f.id, 'name': f.name, 'url': url, 'size': f.size})
    
    # 面包屑
    breadcrumbs = [{'id': 0, 'name': '根目录'}]
    if folder:
        ancestors = []
        f = folder
        while f:
            ancestors.insert(0, {'id': f.id, 'name': f.name})
            f = f.parent
        breadcrumbs.extend(ancestors)
    
    return JsonResponse(data={
        "status": Status.success.value,
        "folder_id": folder_id,
        "folders": folders_data,
        "files": files_data,
        "breadcrumbs": breadcrumbs,
    })


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


# ==================== 文件夹管理 ====================

@login_require
def create_folder(request):
    """新建文件夹"""
    session_id = request.COOKIES.get("session_id")
    user_id = get_user_id_by_session_id(session_id)
    name = _normalize(request.POST.get("name", "").strip())
    parent_id = request.POST.get("parent_id", "").strip()
    if not name:
        return JsonResponse(data={"status": Status.error.value, "message": "请输入文件夹名称"})
    parent = None
    if parent_id and parent_id != "0":
        try:
            parent = Folder.objects.get(id=int(parent_id), user_id=user_id, is_deleted=False)
        except Folder.DoesNotExist:
            return JsonResponse(data={"status": Status.error.value, "message": "父文件夹不存在"})
    f = Folder.objects.create(user_id=user_id, name=name, parent=parent)
    return JsonResponse(data={"status": Status.success.value, "message": "创建成功", "id": f.id, "name": f.name})


@login_require
def rename_folder(request):
    """重命名文件夹"""
    folder_id = int(request.POST.get("id"))
    name = _normalize(request.POST.get("name", "").strip())
    if not name:
        return JsonResponse(data={"status": Status.error.value, "message": "名称不能为空"})
    try:
        f = Folder.objects.get(id=folder_id, is_deleted=False)
        f.name = name
        f.save()
        return JsonResponse(data={"status": Status.success.value, "message": "重命名成功"})
    except Folder.DoesNotExist:
        return JsonResponse(data={"status": Status.error.value, "message": "文件夹不存在"})


@login_require
def delete_folder(request):
    """软删除文件夹 — 同时软删除其下所有子文件夹和文件"""
    f_id = int(request.POST.get("id"))
    try:
        folder = Folder.objects.get(id=f_id, is_deleted=False)
    except Folder.DoesNotExist:
        return JsonResponse(data={"status": Status.error.value, "message": "文件夹不存在"})
    from datetime import datetime
    now = datetime.now()
    # 递归删除所有子文件夹和文件
    def soft_delete_folder(f):
        f.is_deleted = True
        f.deleted_at = now
        f.save()
        for sub in Folder.objects.filter(parent=f, is_deleted=False):
            soft_delete_folder(sub)
        File.objects.filter(folder=f, is_deleted=False).update(is_deleted=True, deleted_at=now)
    soft_delete_folder(folder)
    return JsonResponse(data={"status": Status.success.value, "message": "文件夹已移入回收站"})


@login_require
def restore_folder(request):
    """从回收站恢复文件夹及其上级链"""
    f_id = int(request.POST.get("id"))
    try:
        folder = Folder.objects.get(id=f_id, is_deleted=True)
    except Folder.DoesNotExist:
        return JsonResponse(data={"status": Status.error.value, "message": "文件夹不存在"})
    # 恢复上级链
    def restore_chain(f):
        if f.parent and f.parent.is_deleted:
            restore_chain(f.parent)
        f.is_deleted = False
        f.deleted_at = None
        f.save()
    restore_chain(folder)
    # 恢复子内容
    def restore_children(f):
        for sub in Folder.objects.filter(parent=f, is_deleted=True):
            restore_children(sub)
            sub.is_deleted = False
            sub.deleted_at = None
            sub.save()
        File.objects.filter(folder=f, is_deleted=True).update(is_deleted=False, deleted_at=None)
    restore_children(folder)
    return JsonResponse(data={"status": Status.success.value, "message": "文件夹已恢复"})


@login_require
def permanent_delete_folder(request):
    """彻底删除文件夹 — 递归删子内容 + 文件从 FastDFS 删除"""
    f_id = int(request.POST.get("id"))
    try:
        folder = Folder.objects.get(id=f_id)
    except Folder.DoesNotExist:
        return JsonResponse(data={"status": Status.error.value, "message": "文件夹不存在"})
    def force_delete(f):
        for sub in Folder.objects.filter(parent=f):
            force_delete(sub)
        for fl in File.objects.filter(folder=f):
            try:
                fastdfs_server.delete_file(fl.file_id)
            except Exception:
                pass
            fl.delete()
        f.delete()
    force_delete(folder)
    return JsonResponse(data={"status": Status.success.value, "message": "已彻底删除"})


# ==================== 文件移动 ====================

@login_require
def move_file(request):
    """移动文件到文件夹"""
    session_id = request.COOKIES.get("session_id")
    user_id = get_user_id_by_session_id(session_id)
    file_id = int(request.POST.get("file_id"))
    folder_id = request.POST.get("folder_id", "").strip()
    try:
        f = File.objects.get(id=file_id, user_id=user_id, is_deleted=False)
        current_folder_id = str(f.folder_id) if f.folder_id else "0"
        if current_folder_id == folder_id:
            return JsonResponse(data={"status": Status.warning.value, "message": "已在目标位置"})
        if folder_id and folder_id != "0":
            target = Folder.objects.get(id=int(folder_id), is_deleted=False)
            f.folder = target
        else:
            f.folder = None  # 移到根目录
        f.save()
        return JsonResponse(data={"status": Status.success.value, "message": "移动成功"})
    except File.DoesNotExist:
        return JsonResponse(data={"status": Status.error.value, "message": "文件不存在"})
    except Folder.DoesNotExist:
        return JsonResponse(data={"status": Status.error.value, "message": "目标文件夹不存在"})


# ==================== 分享功能 ====================

@login_require
def create_share(request):
    """创建分享链接（文件或文件夹）"""
    session_id = request.COOKIES.get("session_id")
    user_id = get_user_id_by_session_id(session_id)
    file_id = request.POST.get("file_id", "").strip()
    folder_id = request.POST.get("folder_id", "").strip()
    password = _normalize(request.POST.get("password", "").strip())
    expire_hours = int(request.POST.get("expire_hours", "24"))
    
    share = Share(user_id=user_id, password=password, expire_hours=expire_hours)
    
    if folder_id:
        try:
            folder = Folder.objects.get(id=int(folder_id), user_id=user_id, is_deleted=False)
            share.folder = folder
        except Folder.DoesNotExist:
            return JsonResponse(data={"status": Status.error.value, "message": "文件夹不存在"})
    elif file_id:
        try:
            f = File.objects.get(id=int(file_id), user_id=user_id, is_deleted=False)
            share.file = f
        except File.DoesNotExist:
            return JsonResponse(data={"status": Status.error.value, "message": "文件不存在"})
    else:
        return JsonResponse(data={"status": Status.error.value, "message": "请选择文件或文件夹"})
    
    share.save()
    share_url = request.build_absolute_uri(f"/fdfs/share/{share.code}/")
    return JsonResponse(data={
        "status": Status.success.value,
        "message": "分享链接已生成",
        "share_url": share_url,
        "code": share.code,
        "has_password": bool(password),
    })


def share_page(request, code):
    """分享访问页面 — 无需登录"""
    try:
        share = Share.objects.get(code=code)
    except Share.DoesNotExist:
        return render(request, 'share.html', {'error': '分享链接不存在或已失效'})
    if share.is_expired():
        return render(request, 'share.html', {'error': '分享链接已过期'})
    share.view_count += 1
    share.save()
    
    is_folder = share.folder is not None
    files = []
    
    if is_folder:
        folder = share.folder
        folder_files = File.objects.filter(folder=folder, is_deleted=False)
        for f in folder_files:
            f.url = settings.FASTDFS_FILE_PATH.get(f.file_id.split('/M00/')[0])['url_format'].format(
                f.file_id.split('/M00/')[1])
            files.append({'id': f.id, 'name': f.name, 'url': f.url, 'size': f.size})
    else:
        file = share.file
        if file:
            file.url = settings.FASTDFS_FILE_PATH.get(file.file_id.split('/M00/')[0])['url_format'].format(
                file.file_id.split('/M00/')[1])
            files.append({'id': file.id, 'name': file.name, 'url': file.url, 'size': file.size})
    
    return render(request, 'share.html', {
        'share': share,
        'files': files,
        'is_folder': is_folder,
        'folder_name': share.folder.name if is_folder else '',
        'require_password': bool(share.password),
    })


@csrf_exempt
def verify_share(request):
    """验证分享密码"""
    code = request.POST.get("code")
    password = _normalize(request.POST.get("password", "").strip())
    try:
        share = Share.objects.get(code=code)
    except Share.DoesNotExist:
        return JsonResponse(data={"status": Status.error.value, "message": "分享不存在"})
    if share.is_expired():
        return JsonResponse(data={"status": Status.error.value, "message": "分享已过期"})
    if share.password and share.password != password:
        return JsonResponse(data={"status": Status.error.value, "message": "密码错误"})
    file = share.file
    file.url = settings.FASTDFS_FILE_PATH.get(file.file_id.split('/M00/')[0])['url_format'].format(
        file.file_id.split('/M00/')[1])
    return JsonResponse(data={
        "status": Status.success.value,
        "url": file.url,
        "name": file.name,
    })
