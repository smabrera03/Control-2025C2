%Punto de equilibrio

%Parámetros
m = 1600; %masa
Tm = 190; %algo del torque
wm = 420; %algo del torque
beta = 0.4; %algo del torque
alfa4 = 12;%relación de engranajes
g = 9.8; %gravedad
tita = 4 * pi/180; %tita en radianes
Cr = 0.01; %coeficiente de fricción
rho = 1.3; %densidad del aire
Cd = 0.32; %coeficiente de drag
Af = 2.4; %area frontal del auto
wn = 2 * pi; % polo del actuador
vo = 20; %velocidad de equilibrio

%calculo u_hat de equilibrio

numerador = m * g * sin(tita) + m * g * Cr + 0.5 * rho * Cd * Af * vo^2;
denominador = alfa4 * Tm * (1 - beta * (alfa4 * vo / wm - 1)^2);

u_hat_e = numerador/denominador;


%Linealización

syms x1 x2 x3 u y;

x1e = 20;
x2e = u_hat_e;
x3e = 0;
xe = [x1e; x2e; x3e];

ye = 20;
ue = u_hat_e;

%df1/dx1 en el eq:
alfa4 * Tm / m * x2e * ( - beta * 2 * (alfa4/wm * x1e - 1) * alfa4/wm) - rho/m * Cd * Af * x1e;

%df1/dx2
alfa4 * Tm / m * (1 - beta * (alfa4/wm * x1e - 1)^2);

%Compruebo:

x = [x1; x2; x3];
f1 = alfa4/m * Tm * (1 - beta * (alfa4 / wm * x1 - 1)^2) * x2 - 0.5 * rho/m * Cd * Af * x1^2 - g * sin(tita) - g * Cr;
f2 = x3;
f3 = -wn^2 * x2 - 2 * wn * x3 + wn^2 * u;
f = [f1; f2; f3];

y = x1;

jacA = jacobian(f, x);
jacB = jacobian(f, u);
jacC = jacobian(y, x); %class(jacC) = 'sym'
jacD = jacobian(y, u);

A = subs(jacA, {x1, x2, x3}, {x1e, x2e, x3e}); % class(A) = 'sym'
A = double(A); %class(A) = 'double'

B = subs(jacB, {u}, {ue});
B = double(B);

C = subs(jacC, {x1, x2, x3}, {x1e, x2e, x3e});
C = double(C);

D = subs(jacD, {u}, {ue});
D = double(D);

[ceros, polos, K] = ss2zp(A, B, C, D);

P = zpk(ceros, polos, K);

%Propongo el controlador:

k = db2mag(-17); %Ajustar dsp
C = zpk([polos(1)], [0], k);

L = minreal(C * P);
figure();
margin(L, {1e-2, 10}); grid On;

T = minreal(L/(1 + L));
figure();
step(T); grid On;

Ts = 0.5;
C_dig = c2d(C, Ts, 'tustin');

%%
%Punto 4, realimentación de estados
clear;

A = 10;
B = -9;
C = 1;
D = -1;

P = ss(A, B, C, D);

K = acker(A, B, -1);
L = acker(A', C', -10)';

kf = 1;