import time
import datetime
import sys

for i in range(3):
  date =  datetime.datetime.now()
  str_ = str(date)
  sys.stdout.write("{msg - (" + str_ + ") = <"+ str(i) + ">}\n")
  sys.stdout.flush() # <--- this was the issue
  time.sleep(1)