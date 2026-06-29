from django.test import TestCase

# Create your tests here.

# Echo server program
import socket
import sys

# HOST = "152.136.160.51"               # Symbolic name meaning all available interfaces
# HOST = "10.0.20.16"               # Symbolic name meaning all available interfaces
i = 0
while i < 10:
    HOST = "192.168.31.21"               # Symbolic name meaning all available interfaces
    PORT = 5555              # Arbitrary non-privileged port
    s = None
    for res in socket.getaddrinfo(HOST, PORT, socket.AF_UNSPEC,
                                  socket.SOCK_STREAM, 0, socket.AI_PASSIVE):
        af, socktype, proto, canonname, sa = res
        try:
            s = socket.socket(af, socktype, proto)
        except OSError as msg:
            s = None
            continue
        try:
            s.bind(sa)
            s.listen(1)
        except OSError as msg:
            s.close()
            s = None
            continue
        break
    if s is None:
        print('could not open socket')
        sys.exit(1)
    conn, addr = s.accept()
    with conn:
        print('Connected%s by' % i, addr)
        while True:
            data = conn.recv(1024)
            if not data: break
            conn.send(data)
    i += 1

# Echo client program
# import socket
# import sys
#
# HOST = '152.136.160.51'    # The remote host
# PORT = 5555              # The same port as used by the server
# s = None
# for res in socket.getaddrinfo(HOST, PORT, socket.AF_UNSPEC, socket.SOCK_STREAM):
#     af, socktype, proto, canonname, sa = res
#     try:
#         s = socket.socket(af, socktype, proto)
#     except OSError as msg:
#         s = None
#         continue
#     try:
#         s.connect(sa)
#     except OSError as msg:
#         s.close()
#         s = None
#         continue
#     break
# if s is None:
#     print('could not open socket')
#     sys.exit(1)
# with s:
#     s.sendall(b'Hello, world')
#     data = s.recv(1024)
# print('Received', repr(data))
