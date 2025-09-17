a = [1 1/2 3/2 1/4 0]; %coeficientes del denominador
b = [0 0 0 0 1/2]; %coeficientes del numerador
H = tf(b, a);

A = [0 0 1 0; 0 0 0 1; -1 1 -1/2 0; 1/2 -1/2 0 0];
B = transpose([0 0 0 1/2]);
C = [1 0 0 0];
D = 0;

[b_check, a_check] = ss2tf(A, B, C, D);

H_check = tf(b_check, a_check);

display(H)
display(H_check)
%Misma transferencia excepto por un pequeño error, probablemente numérico

%respuesta al escalón
figure;
step(H, 0:0.1:10)
grid on

syms s
I = eye(4);
mat = s*i - A;
matinv = inv(mat);

ilaplace(matinv)

%respuesta al impulso:
figure;
impulse(H)
grid on
legend('Respuesta al impulso del sistema')

%Respuesta a una condición inicial
IC = [0 1 0 0]; %posición inicial de m2 = 1
sys = ss(A, B, C, D);
figure;
initial(sys, IC)


