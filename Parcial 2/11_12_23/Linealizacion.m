syms x1 x2 x3 x4 x5 y u;

x = [x1;x2;x3;x4;x5];

wn = 2*pi*100;

f1 = x2;
f2 = sin(x1) + x3;
f3 = x4;
f4 = x5;
f5 = -wn^3 * x3 - 3*wn^2 * x4 - 3*wn * x5 + wn^3 * u;

f = [f1;f2;f3;f4;f5];

y = x1;

%puntos de equilibrio
x1e = pi/6;
x2e = 0;
x3e = -1/2;
x4e = 0;
x5e = 0;

ue = -1/2;
ye = pi/6;

jacA = jacobian(f, x);
jacB = jacobian(f, u);
jacC = jacobian(y, x);
jacD = jacobian(y, u);

A = subs(jacA, {x1, x2, x3, x4, x5}, {x1e, x2e, x3e, x4e, x5e}); % class(A) = 'sym'
A = double(A); %class(A) = 'double'

B = subs(jacB, {u}, {ue});
B = double(B);

C = subs(jacC, {x1, x2, x3, x4, x5}, {x1e, x2e, x3e, x4e, x5e});
C = double(C);

D = subs(jacD, {u}, {ue});
D = double(D);

%paso a tf:
[ceros, polos, k] = ss2zp(A, B, C, D);

sistema = ss(A, B, C, D);
P = tf(sistema);

%%
%Diseño el controlador
p1 = polos(1); %polo inestable
p2 = polos(2); % -p1
p3 = polos(3);
p4 = polos(4); %parte imaginaria muy chica. p3, p4 y p5 podrían ser un polo triple
p5 = polos(5);

%intento seguir el método que está en el campus.
p1 = real(p3); %polo triple

P = zpk([], [p1, p1, p1, p2, -p2], k);

Pmp = zpk( [], [p1, p1, p1, p2, p2], k);
Pap = zpk( [p2], [-p2], 1);

opt = bodeoptions;
opt.grid = 'On';
opt.PhaseMatching = 'on';
opt.PhaseMatchingValue = -180;
opt.PhaseMatchingFreq = 1;

%%
opt.MagVisible = 'off';
bode(Pap, opt);
hold on
bode(Pmp, opt, {0.1, 100}); title('Pap y Pmp');
legend('Pap', 'Pmp');

%%
opt.MagVisible = 'on';
bode(Pmp, opt); title('Pmp');

%%
alfa = db2mag(75.6);
C = zpk([p2, p2], [0, -600], alfa);

CPmp = minreal(C * Pmp, 0.01);

figure;
opt.MagVisible = 'off';
bode(CPmp, opt, {0.1, 100});
hold on
bode(Pap, opt, {0.1, 100}); title('Fase de CPmp y Pap');
legend('CPmp', 'Pap');

%%
figure;
opt.MagVisible = 'on';

bode(minreal(C * P), opt, {0.1, 100}); title('L');
hold on
%observo que para que wgc = 10, alfa = 75.6dB
%%
%añado el pade
Ts = 0.01;
pade = zpk([4/Ts], [-4/Ts], -1);
bode(minreal(C * P * pade), opt, {0.1, 100}); title('L con padé');

