#!/usr/bin/env python
from time import sleep
import os
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BOARD)
GPIO.setup(5, GPIO.IN) # SHUTDOWN
GPIO.setup(7, GPIO.OUT) # SHUTDOWN BUSY
GPIO.output(7, GPIO.LOW)

while True:
        if ( GPIO.input(5)== GPIO.LOW ):
             # tue or false here depends on your button type
             # when in doubt replace 'reboot &' in the following line with 'echo "pushed" &'
                GPIO.output(7, GPIO.HIGH)
                os.system('shutdown -h now &')
        sleep(0.1);

