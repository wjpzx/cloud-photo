from fdfs_client.client import Fdfs_client, get_tracker_conf


# 定义fastdfs服务端
class FastServer:
    def __init__(self, conf='./utils/client.conf'):
        conf_file = get_tracker_conf(conf)
        self.client = Fdfs_client(conf_file)

    def upload_file(self, content, file_suffix_name=''):
        # 调用其二进制上传文件方法
        # print("conten====", content)
        result = self.client.upload_by_buffer(content, file_ext_name=file_suffix_name)
        return result

    def download_file(self, file_id, filename):
        file_id = file_id.encode()
        self.client.download_to_file(filename, file_id)

    def delete_file(self, fil_id):
        fil_id = fil_id.encode()
        self.client.delete_file(fil_id)


fastdfs_server = FastServer()
