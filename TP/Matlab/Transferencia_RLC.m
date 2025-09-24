A = [-10,-10,1.000000000000000e+05;-5,-5,0;-3.636363636363637e+02,0,0];
B = [10;5;3.636363636363637e+02];
C = [0,1,0];
D = 0;
B_raro = [5;10;3.636363636363637e+02];%primeros coeficientes invertidos

[num, den] = ss2tf(A, B, C, D);


[num_raro, den_raro] = ss2tf(A, B_raro, C, D);


format short e;
display(num)
display(den)
display(num_raro)
display(den_raro)

