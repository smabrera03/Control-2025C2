%%
A = [-2 -1; 0 -4];
B = [1; 0];
C = [1 1];
D = 0;
%polos en -2 y -4. Cero en -4. Estable


[Z, P, k] = ss2zp(A, B, C, D);
Planta = minreal(zpk(Z, P, k));

figure();
step(Planta);title('step de la planta');
grid On;

T = minreal(Planta/(1 + Planta)); %polos en -3, -4
figure();
step(T);title('Step del sistema de lazo cerrado');
grid On;

ki = 10;