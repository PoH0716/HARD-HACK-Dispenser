from serial import Serial
import time

port = Serial("COM7", baudrate=115200, timeout=3.0)

for i in range(1, 3):
    port.write(str.encode(("KEK"+str(i)+"\r\n")))
    rcv = port.read(5)
    print(rcv)