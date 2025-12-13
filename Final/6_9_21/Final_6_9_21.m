%%
%punto 1: Nyquist

k = 1;

L = zpk([-2], [1 1 1], -k);

opt = bodeoptions();

opt.grid = 'On';
opt.PhaseMatching = 'On';
opt.PhaseMatchingFreq = 1;
opt.PhaseMatchingValue = -180;
opt.PhaseWrapping = 'Off';
opt.Xlim = [0.1, 100];

figure();bode(L, opt); title('L');

%%
%Punto 2: diseño
clear;

opt = bodeoptions();
opt.grid = 'On';
opt.PhaseMatching = 'On';
opt.PhaseMatchingFreq = 1;
opt.PhaseMatchingValue = -180;

P = zpk([1000 1000 1000], [1 1 1], 1);

Pap = zpk([-1 -1 -1 1000 1000 1000], [1 1 1 -1000 -1000 -1000], -1);

Pmp = zpk([-1000 -1000 -1000], [-1 -1 -1], -1);

k = db2mag(31);
C = zpk([-1 -1 -1], [0 -1000 -1000 -1000], -k);

L = minreal(C * P);
figure(); bode(L, opt); title('L');

%%
%Linealización
clear; close all;
syms x1 x2 y u;

x = [x1; x2];
f1 = -sqrt(x1 - x2) + u;
f2 = sqrt(x1 - x2) - sqrt(x2);
f = [f1; f2];
y = x1;

x1e = 8;
x2e = 4;
xe = [x1e; x2e];
ue = 2;
ye = 8;

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

P = zpk(ceros, polos, K);

opt = bodeoptions();
opt.grid = 'On';
opt.PhaseMatching = 'On';
opt.PhaseMatchingFreq = 1;
opt.PhaseMatchingValue = -180;

k = db2mag(35);
C = zpk([polos(2)], [0 -10], k);
Ts = 0.03;
Pade = zpk(4/Ts, -4/Ts, -1);

L = minreal(P * C * Pade);

figure(); bode(L, opt); title('L');

T = minreal(L/(1 + L));

figure(); step(T, 10); grid 'On';

figure(); bode(T, opt); title('T');

S = minreal(1/(1 + L));

figure(); bode(S, opt); title('S');
%ANDA FLAMA

C_dig = c2d(C, Ts, 'tustin');

%%
% Punto 4
clear; close all;clc;

opt = bodeoptions();
opt.grid = 'On';
opt.PhaseMatching = 'On';
opt.PhaseMatchingFreq = 1;
opt.PhaseMatchingValue = -180;
opt.MagVisible = 'off';

P = zpk([1 2], [7 8], 1);
Pmp = zpk([-1 -2], [-7 -8], 1);
Pap = zpk([1 2 -7 -8], [-1 -2 7 8], 1);

figure(); bode(Pap, opt, {0.1, 1000}); title('Bode Pap');

ceros_pap = zpk([1 2], [-1 -2], 1);
polos_pap = zpk([-7 -8], [7 8], 1);

figure(); bode(ceros_pap, polos_pap, opt, {0.1, 1000}); title('Fases por los polos y los ceros'); legend();

s = tf('s');
k = db2mag(0);
C = k * (s)^2 / (s + 10000)^2;

L = minreal(C * P);

opt.MagVisible = 'On';
figure();bode(L, opt, {0.1, 1000}); title('L');

%%
%Por realimentación de estados con observador
clear; close all; clc
A = [7, 0; 0, 8];
B = [-3; 15];
C = [1, 1];
D = 1;

Wr = [B, A*B];

a1 = -15;
a2 = 56;

p1 = 2;
p2 = 1;

Wrm = inv([1, a1; 0, 1]);

K = [p1 - a1, p2 - a2] * Wrm * inv(Wr);
acker(A, B, [-1 -1]); %igual

Wom = inv([1, 0; a1, 1]);
Wo = [1, 1; 7, 8];

o1 = 20; 
o2 = 100;

L = inv(Wo) * Wom *  [o1 - a1; o2 - a2];
ac = acker(A', C', [-10 -10])';

Acon = A - B*K - L*C + L * D * K;
Bcon = L;
Ccon = -K;
Dcon = 0;

controlador = ss(Acon, Bcon, Ccon, Dcon);

[ceros, polos, gan] = ss2zp(Acon, Bcon, Ccon, Dcon);

C = zpk(ceros, polos, gan);

opt = bodeoptions();
opt.grid = 'On';
opt.PhaseMatching = 'On';
opt.PhaseMatchingFreq = 1;
opt.PhaseMatchingValue = -180;
opt.MagVisible = 'off';

P = zpk([1 2], [7 8], 1);

L = minreal(C * P);

opt.MagVisible = 'On';
figure();bode(L, opt, {0.1, 1000}); title('L');

%estable mis huevos
