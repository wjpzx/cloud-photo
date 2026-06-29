import ftplib
import MySQLdb
import pymysql
from pymysql import connections
from pymysql import cursors

# pymysql.connect()

# ftp = ftplib.FTP()
# print(ftp.connect('8.142.36.53', 21))


class DataChange(connections.Connection):
    def __init__(self, host, port, user, password, database):

        super(DataChange, self).__init__(host=host, port=port, user=user, password=password, database=database)

    def add(self):
        self.cursor()


# import socket
# s = socket.create_connection(('8.142.36.53', 22022))
# print(s) a

dc = DataChange(host='10.0.1.37', port=3306, user='root', password='artmysqlpass', database='art_online',)
# dc.connect()
db = dc.cursor(cursor=cursors.DictCursor)
db1 = dc.cursor()
db2 = dc.cursor()
db.execute("select * from user where id=1")
result = db.fetchall()
dc.commit()
dc.close()
print(result, dc, db)
