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
    # 文件夹
    re_path(r'^folder/create/', create_folder, name='create_folder'),
    re_path(r'^folder/rename/', rename_folder, name='rename_folder'),
    re_path(r'^folder/delete/', delete_folder, name='delete_folder'),
    re_path(r'^folder/restore/', restore_folder, name='restore_folder'),
    re_path(r'^folder/permanent_delete/', permanent_delete_folder, name='permanent_delete_folder'),
    # 文件移动
    re_path(r'^move_file/', move_file, name='move_file'),
    # 分享
    re_path(r'^share/create/', create_share, name='create_share'),
    re_path(r'^share/verify/', verify_share, name='verify_share'),
    re_path(r'^share/(?P<code>[a-zA-Z0-9\-]+)/$', share_page, name='share_page'),
    path('logout/', logout, name='logout'),
    path('reset_password/', reset_password, name='reset_password'),
]
