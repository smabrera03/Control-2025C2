s = tf('s')
P = 1/((s-i)*(s+i))
PAP = (s+1)/(s-1)
bode(PAP);
grid On