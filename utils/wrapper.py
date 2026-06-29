from functools import wraps

from django.http import JsonResponse
from django.shortcuts import redirect
from django.urls import reverse

from fdfs.models import Status
from utils import redis


def login_require(func):
    @wraps(func)
    def wrapper(request, *args, **kwargs):
        session_id = request.COOKIES.get("session_id")
        phone = redis.get_phone_by_session_id(session_id)
        if phone:
            return func(request, *args, **kwargs)
        else:
            # 记录当前完整URL，登录后跳回
            full_path = request.get_full_path()
            login_url = reverse("login") + "?next=" + full_path
            return redirect(login_url)

    return wrapper
