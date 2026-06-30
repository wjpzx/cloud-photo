from django.urls import re_path, path

from fdfs.views import *
urlpatterns = [
    re_path(r'^index/$', index, name="index"),
    re_path(r'^login/$', LoginView.as_view(), name="login"),
    re_path(r'^send/$', send_verification_code, name="send"),
    re_path(r'^set_pass/$', set_pass, name="set_pass"),
    re_path(r'^upload/$', create, name='upload_file'),
    re_path(r'^delete/', delete, name='delete_file'),
    re_path(r'^recycle/$', recycle_bin, name='recycle_bin'),
    re_path(r'^restore/', restore_file, name='restore_file'),
    re_path(r'^permanent_delete/', permanent_delete, name='permanent_delete'),
    re_path(r'^move/', move_pic, name='move_photo_to_folder'),
    path('logout/', logout, name='logout'),
    path('reset_password/', reset_password, name='reset_password'),
]
