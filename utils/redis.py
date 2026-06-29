from django_redis import get_redis_connection
import hashlib
import time


def set_code_phone(phone, code):
    redis = get_redis_connection("send_sms")
    res = redis.set("%s_sms_code" % phone, code, ex=300)
    return res


def get_code_phone(phone):
    redis = get_redis_connection("send_sms")
    code = redis.get("%s_sms_code" % phone)
    return code


def set_session_id(phone, user_id):
    md5 = hashlib.md5()
    string = ("%s_%s" % (phone, time.time())).encode()
    md5.update(string)
    session_id = md5.hexdigest()
    redis = get_redis_connection("session")
    redis.set("session_by_%s" % session_id, phone)
    redis.set("session_by_%s" % phone, session_id)
    redis.set("session_by_user_id_%s" % session_id, user_id)

    return session_id


def get_session_id(phone):
    redis = get_redis_connection("session")
    session_id = redis.get("session_by_%s" % phone)
    return session_id


def get_phone_by_session_id(session_id):
    redis = get_redis_connection("session")
    phone = redis.get("session_by_%s" % session_id)
    return phone


def get_user_id_by_session_id(session_id):
    redis = get_redis_connection("session")
    user_id = redis.get("session_by_user_id_%s" % session_id)
    return user_id


def check_sms_rate_limit(phone):
    """Check if the phone has sent SMS within the last 60 seconds. Returns True if allowed, False if rate limited."""
    redis = get_redis_connection("send_sms")
    key = "sms_rate_%s" % phone
    if redis.exists(key):
        return False
    redis.set(key, 1, ex=60)
    return True


def check_sms_daily_limit(phone):
    """Check if the phone has exceeded 10 SMS per day. Returns True if allowed, False if exceeded."""
    redis = get_redis_connection("send_sms")
    key = "sms_daily_%s" % phone
    count = redis.incr(key)
    if count == 1:
        redis.expire(key, 86400)
    if count > 10:
        return False
    return True


def check_sms_ip_limit(ip):
    """Check if the IP has exceeded 20 SMS per hour. Returns True if allowed, False if exceeded."""
    redis = get_redis_connection("send_sms")
    key = "sms_ip_%s" % ip
    count = redis.incr(key)
    if count == 1:
        redis.expire(key, 3600)
    if count > 20:
        return False
    return True
