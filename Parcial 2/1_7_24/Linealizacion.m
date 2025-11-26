syms x1 x2 u y;
x = [x1; x2];

f1 = - sqrt(x1 - x2) + u;
f2 = sqrt(x1 - x2) - sqrt(x2);
f = [f1; f2];

y = x2;

x1e = 2;
x2e = 1;
ue = 1;
ye = 1;

jacA = jacobian(f, x);
jacB = jacobian(f, u);
jacC = jacobian(y, x); %class(jacC) = 'sym'
jacD = jacobian(y, u);

A = subs(jacA, {x1, x2}, {x1e, x2e}); % class(A) = 'sym'
A = double(A); %class(A) = 'double'

B = subs(jacB, {u}, {ue});
B = double(B);

C = subs(jacC, {x1, x2}, {x1e, x2e});
C = double(C);

D = subs(jacD, {u}, {ue});
D = double(D);

%paso a tf:
[ceros, polos, K] = ss2zp(A, B, C, D);

sistema = ss(A, B, C, D);
P = tf(sistema);

%%
bode(P);
grid On;
title('Bode de P (linealizada)');

%%
k = db2mag(3);
s = tf('s');
alfa = polos(2);
C = k * (s - alfa)/s;

L = minreal(C * P);

figure();
margin(L); grid On;

Ts = 0.01;
L_digi = c2d(L, Ts, 'tustin');

figure();
margin(L_digi); grid On;

%%
L_digi = L * (1 - Ts/4 * s)/(1 + Ts/4 * s);

T = L_digi/(1 + L_digi);

step(0.2 * T); grid On;
hold on

CS = C/(1 + L_digi);
step(0.2*CS); grid On;
title('Respuestas al escalón de T y de CS');
legend('T', 'CS');
hold off;

%%
%capaz debería hacerlo así:
T = L / (1 + L);
CS = C / (1 + L);

T_digi = c2d(T, Ts, 'tustin');
CS_digi = c2d(CS, Ts, 'tustin');

step(0.2*T_digi); grid On;
hold on;

step(0.2*CS_digi); grid On;
legend('T', 'CS');


%%
Ts = 0.1;
C_digital = c2d(C, Ts, 'tustin');



