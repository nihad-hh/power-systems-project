from math import pi
flag=0
lines=[]
with open('PF_My9_Res.txt') as f:
  for line in f.readlines():
    if line.strip().startswith('SOLUTION DATA'):
      flag=1
    if flag:
      lines.append(line.strip())

for i,line in enumerate(lines):
  if line and line[0].isnumeric():
    if int((line.split('.'))[0]) %2==1:
      print(round(float(lines[i+1].split('=')[-1]),4),round(float(line.split('=')[-1])*180/pi,4))