A = [-2 1; -1 0];
B = [1; 0];
C = [1 0];
D = 0;

Planta = ss(A, B, C, D);

step(P); grid On;

[Z, P, K] = ss2zp(A, B, C, D);

%diseñado a mano, ver rnote
L = [18; 99];

%Otra opción, más rápida y con menos overshoot. La saqué tanteando
%L = [198; 250];

eig(A - L*C)