import RPi.GPIO as GPIO
import time

RST = 18

GPIO.setmode(GPIO.BCM)
GPIO.setup(RST, GPIO.OUT, initial=GPIO.HIGH)

def rak_reset():
    GPIO.output(RST, GPIO.LOW)
    time.sleep(3)   # 3s
    GPIO.output(RST, GPIO.HIGH)

rak_reset()
