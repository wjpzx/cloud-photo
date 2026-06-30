from django.db import models
from enum import Enum

# Create your models here.


class Status(Enum):
    error = -1
    success = 0
    warning = 1


class Category(models.Model):

    name = models.CharField(verbose_name='文件夹名称', max_length=25)
    create_time = models.DateTimeField(verbose_name="创建时间", auto_now_add=True)
    modify_time = models.DateTimeField(verbose_name="修改时间", auto_now=True)


class File(models.Model):
    user = models.ForeignKey("User", on_delete=models.CASCADE, verbose_name="user_id")
    name = models.CharField(verbose_name="文件名", max_length=50)
    file_id = models.CharField(verbose_name="文件ID", max_length=100)
    size = models.CharField(verbose_name="文件大小", max_length=10)
    create_time = models.DateTimeField(verbose_name="创建时间", auto_now_add=True)
    modify_time = models.DateTimeField(verbose_name="修改时间", auto_now=True)
    is_deleted = models.BooleanField(verbose_name="是否删除", default=False)
    deleted_at = models.DateTimeField(verbose_name="删除时间", null=True, blank=True)


class User(models.Model):

    name = models.CharField(verbose_name='用户名', max_length=30)
    phone = models.CharField(verbose_name='手机号', max_length=11)
    passwd = models.CharField(verbose_name='密码', max_length=50)
    create_time = models.DateTimeField(verbose_name='创建时间', auto_now_add=True)
    modify_time = models.DateTimeField(verbose_name='修改时间', auto_now=True)