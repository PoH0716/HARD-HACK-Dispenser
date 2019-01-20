import socket
from serial import Serial
import time

port = Serial("COM7", baudrate=115200, timeout=3.0)
HOST = '127.0.0.1'  # Standard loopback interface address (localhost)
PORT = 5556        # Port to listen on (non-privileged ports are > 1023)
buffer = "";

while True:
  with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
      s.bind((HOST, PORT))
      s.listen()
      conn, addr = s.accept()
      with conn:
          print('Connected by', addr)
          while True:
              data = conn.recv(1024)
              if not data:
                  break
              conn.sendall(data)
              port.write(data)
              print(data)