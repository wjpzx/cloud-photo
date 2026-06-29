from django.conf import settings

from ronglian_sms_sdk import SmsSDK

# from upload import settings


class SendSms():

    def __init__(self):
        self._accId = settings.sms_send['ronglianyun'].accId
def send_sms():

