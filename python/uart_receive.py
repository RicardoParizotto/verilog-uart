"""
========================================================
Coded by: circuitfever.com
License: MIT License
Description: Python script to send data through PC to 
FPGA receiver.
========================================================
"""

from serial import Serial

START_BYTE = b'\x00'

com_port = 'COM4'           #replace this with com port of the USB-UART bridge
baudrate = 9600
ser = Serial(port=com_port,baudrate=baudrate,timeout=1)

#data = b'\x10'
#bytes_to_read = len(data)

#print(bytes_to_read)
#ser.write(data)

while(True):
    if ser.in_waiting > 0:
        print(ser.in_waiting)
        data_received = ser.read(2) 
        print(f"Bytes recebidos: {data_received.hex()}")

ser.close()