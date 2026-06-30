from django.db import models
from enum import Enum
import uuid


class Status(Enum):
    error = -1
    success = 0
    warning = 1


class Folder(models.Model):
    """文件夹模型 — 支持嵌套"""
    user = models.ForeignKey("User", on_delete=models.CASCADE, verbose_name="用户")
    name = models.CharField(verbose_name="文件夹名称", max_length=50)
    parent = models.ForeignKey("self", on_delete=models.CASCADE, null=True, blank=True, verbose_name="父文件夹")
    create_time = models.DateTimeField(verbose_name="创建时间", auto_now_add=True)
    modify_time = models.DateTimeField(verbose_name="修改时间", auto_now=True)
    is_deleted = models.BooleanField(verbose_name="是否删除", default=False)
    deleted_at = models.DateTimeField(verbose_name="删除时间", null=True, blank=True)

    class Meta:
        verbose_name = "文件夹"
        verbose_name_plural = "文件夹"

    def __str__(self):
        return self.name


class Category(models.Model):
    name = models.CharField(verbose_name='文件夹名称', max_length=25)
    create_time = models.DateTimeField(verbose_name="创建时间", auto_now_add=True)
    modify_time = models.DateTimeField(verbose_name="修改时间", auto_now=True)


class File(models.Model):
    user = models.ForeignKey("User", on_delete=models.CASCADE, verbose_name="user_id")
    folder = models.ForeignKey(Folder, on_delete=models.SET_NULL, null=True, blank=True, verbose_name="所属文件夹")
    name = models.CharField(verbose_name="文件名", max_length=50)
    file_id = models.CharField(verbose_name="文件ID", max_length=100)
    size = models.CharField(verbose_name="文件大小", max_length=10)
    create_time = models.DateTimeField(verbose_name="创建时间", auto_now_add=True)
    modify_time = models.DateTimeField(verbose_name="修改时间", auto_now=True)
    is_deleted = models.BooleanField(verbose_name="是否删除", default=False)
    deleted_at = models.DateTimeField(verbose_name="删除时间", null=True, blank=True)


class Share(models.Model):
    """分享链接模型"""
    file = models.ForeignKey(File, on_delete=models.CASCADE, verbose_name="分享文件")
    user = models.ForeignKey("User", on_delete=models.CASCADE, verbose_name="分享者")
    code = models.CharField(verbose_name="分享码", max_length=36, unique=True, default=uuid.uuid4)
    password = models.CharField(verbose_name="访问密码", max_length=6, blank=True, default="")
    expire_hours = models.IntegerField(verbose_name="有效期(小时)", default=24)
    create_time = models.DateTimeField(verbose_name="创建时间", auto_now_add=True)
    view_count = models.IntegerField(verbose_name="浏览次数", default=0)

    class Meta:
        verbose_name = "分享"
        verbose_name_plural = "分享"

    def is_expired(self):
        from datetime import datetime, timedelta
        return datetime.now() > self.create_time.replace(tzinfo=None) + timedelta(hours=self.expire_hours)

    def __str__(self):
        return f"{self.file.name} → {self.code}"


class User(models.Model):
    name = models.CharField(verbose_name='用户名', max_length=30)
    phone = models.CharField(verbose_name='手机号', max_length=11)
    passwd = models.CharField(verbose_name='密码', max_length=50)
    create_time = models.DateTimeField(verbose_name='创建时间', auto_now_add=True)
    modify_time = models.DateTimeField(verbose_name='修改时间', auto_now=True)
