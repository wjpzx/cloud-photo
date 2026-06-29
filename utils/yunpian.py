import requests
import json
import random

# from django.conf import settings


# 生成随机验证码
from upload import settings
from utils import redis


class YunPian(object):
    def __init__(self):
        self.__api_key = settings.SmsSend['yunpian']['api_key']
        self.__single_send_url = "https://sms.yunpian.com/v2/sms/single_send.json"

    def __get_random_code(self):
        verify_code = ''
        for i in range(6):
            i = random.randint(0, 9)
            verify_code += str(i)
        return verify_code

    def send_sms(self, mobile):
        code = self.__get_random_code()

        redis.set_code_phone(mobile, code)

        # 需要传递的参数
        params = {
            "apikey": self.__api_key,
            "mobile": mobile,
            "text": "【云相册】欢迎使用云相册，您的验证码是%s。如非本人操作，请忽略本短信" % code
        }

        response = requests.post(self.__single_send_url, data=params)
        re_dict = json.loads(response.text)
        # re_dict = {
        #         "code": 0,
        #         "msg": "发送成功",
        #         "count": 1,
        #         "fee": 0.05,
        #         "unit": "RMB",
        #         "mobile": "13200000000",
        #         "sid": 3310228982,
        #         "sms_code": code
        #     }

        return re_dict


yunpian = YunPian()

# 云片网短信验证码服务
# class YPWMessage(DefaultMessage):
#     def __init__(self):
#         self.name = 'ypw_message'
#         self.api_key = settings.SMS_CONF[self.name]['api_key']
#
#     # 发送短信验证码
#     def send_message(self, phone):
#         verify_code = self.get_random_code()
#         yun_pian = YunPian(self.api_key)
#
#         sms_status = yun_pian.send_sms(code=verify_code,mobile=phone)
#
#         if not sms_status:
#             logger.logger.error('ypw_message failed')
#             return base_pb2.ERROR, '短信服务异常'
#         # res_status = json.loads(sms_status)
#         logger.logger.info(sms_status)
#         if sms_status['code'] != 0:
#             logger.logger.warning('ypw_message wrong, ' + sms_status['detail'])
#             return base_pb2.WARNING, sms_status['msg']
#
#         common_redis_client.update_verify_code_by_phone(phone, verify_code)
#         return base_pb2.OK, ''


# ypw_message = YPWMessage()
