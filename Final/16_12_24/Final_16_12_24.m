%%
%Punto 1: nyquist
s = tf('s');

k = 1;

L = k/s^3 * (s + 4)^2/(s + 80);

opt = bodeoptions;
opt.grid = 'On';
opt.PhaseMatching = 'On';
opt.PhaseMatchingFreq = 1;
opt.PhaseMatchingValue = -180;

figure(); bode(L, opt); title('Bode de L');

figure(); rlocus(L);

%%
%Punto 2
clear;
opt = bodeoptions;
opt.grid = 'On';
opt.PhaseMatching = 'On';
opt.PhaseMatchingFreq = 1;
opt.PhaseMatchingValue = -180;

s = tf('s');

P = (s - 50)^2 / (s - 1)^2;
Pap = zpk([-1 -1 50 50], [1 1 -50 -50], 1);

k = db2mag(34.6);

C = zpk([-1 -1 -1], [0 -50 -50 -50], k);

L = minreal(C * P);


figure(); bode(Pap, opt); title('Bode de Pap');

figure(); bode(L, opt); title('Bode de L');

S = minreal(1/(1 + L));

T = minreal(L/(1 + L));

PS = minreal(P * S);

figure(); step(T); title('Salida ante el escalón en r');
grid 'On';

figure(); step(PS); title('Salida ante un escalón de perturbación');
grid 'On';

figure(); bode(S, opt); title('Bode de S');

%%
%Punto 3
close all; clear;

opt = bodeoptions;
opt.grid = 'On';
opt.PhaseMatching = 'On';
opt.PhaseMatchingFreq = 1;
opt.PhaseMatchingValue = -180;

syms x1 x2 u y;

x = [x1; x2];

y = x2;

ye = 1;
x1e = 2;
x2e = 1;
ue = 1;
xe = [x1e; x2e];

f1 = (-sqrt(x1 - x2) + u)/x1^2;
f2 = (sqrt(x1 - x2) - sqrt(x2))/x2^2;
f = [f1; f2];

jacA = jacobian(f, x);
jacB = jacobian(f, u);
jacC = jacobian(y, x); %class(jacC) = 'sym'
jacD = jacobian(y, u);

A = subs(jacA, {x1, x2, u}, {x1e, x2e, ue}); % class(A) = 'sym'
A = double(A); %class(A) = 'double'

B = subs(jacB, {x1, u}, {x1e, ue});
B = double(B);

C = subs(jacC, {x1, x2}, {x1e, x2e});
C = double(C);

D = subs(jacD, {u}, {ue});
D = double(D);

%paso a tf:
[ceros, polos, K] = ss2zp(A, B, C, D);

sistema = ss(A, B, C, D);
P = zpk(ceros, polos, K); %esta es solo la parte no lineal de la planta

s = tf('s');

p = 0.02; %polo del actuador
H = p/(s + p);
P = minreal(P *H);


k = db2mag(112.3);

C = zpk([polos(1), polos(2), -p], [0, -10 -10 -10], k);

L = minreal(P * C);

figure();bode(L, opt, {0.1, 100}); title('Bode de L');

T = L/(1 + L );

S = minreal(1/(1 + L));

%figure();bode(S, opt, {0.1, 100}); title('Bode de S');

Ts = 0.5;
C_dig = c2d(C, Ts, 'tustin');

Pade  = zpk(4/Ts, -4/Ts, -1);
P_final = minreal(P * Pade);
L_final = minreal(C * P_final);

figure(); bode(Pade, opt, {0.01, 100}); title('Pade');
figure();bode(L_final, opt, {0.01, 100}); title('L con pade');


%%
%Realimentación de estados

A = [-1/8, 1/8, 1/4; 1/2, -1, 0; 0, 0, 0.02];
B = [0; 0; 0.02];
C = [0, 1, 0] ;
D = 0;

Aa = [A, zeros(3, 1); -C, 0];
Ba = [B; 0];
Ka = acker(Aa, Ba, [-1 -1 -1 -1]);

K = Ka(1:3);
ki =  - Ka(end);

xe = [2; 1; 1];

