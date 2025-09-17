a = [1 1 1] %coeficientes del denominador
b = 1 %coeficientes del numerador
H = tf(b, a);

A = [0 1; -1 -1];
B = transpose([0 1]);
C = [1 0];
D = 0;

[b_check, a_check] = ss2tf(A, B, C, D);

H_check = tf(b_check, a_check);

display(H)
display(H_check)
%Misma transferencia

%respuesta al escalón:
t = 0:0.1:10; %de 0, con incremento 0.1 hasta 10

%respuesta analítica al escalón
y = 1 - (exp(-t/2)).*(cos(sqrt(3/4)*t) + 1/sqrt(3)*sin(sqrt(3/4)*t));

figure;
plot(t, y, '--r', 'LineWidth', 1.5)
hold on
step(H, 'b')
hold off
grid on
legend('respuesta calculada', 'respuesta simulada')

syms s
mat = [s 0; 0 s] - A;
matinv = inv(mat);

ilaplace(matinv)
%es la que calculé

%respuesta al impulso:
figure;
impulse(H)
grid on
legend('Respuesta al impulso del sistema')

%Respuesta a una condición inicial
IC = [0 1]; %Posición inicial 0. Velocidad inicial 1 m/s
sys = ss(A, B, C, D);
figure;
initial(sys, IC)
