tau = 40e-3;
Ts = 20e-3;
p = 1/2;

Pmp = zpk([], -p, 1);
Pap = zpk([-p, 2/tau, 4/Ts], [p, -2/tau, -4/Ts], 1);
Pap0 = zpk([-p, 2/tau], [p, -2/tau], -1);

P0 = minreal(Pmp * Pap0);
P = minreal(Pmp * Pap);

opt = bodeoptions;
opt.grid = 'on';
opt.PhaseMatching = 'on';
opt.PhaseMatchingValue = -180;
opt.PhaseMatchingFreq = 1;

figure(1);
opt.MagVisible = 'off';
bode(Pap, opt); hold on
bode(Pap0, opt); 
legend('Pap', 'Pap0');title('Fase Pap y Pap0');


%defino C
k = db2mag(0);
C = zpk(-p, 0, k);

L = minreal(C * P);

figure(2);
opt.MagVisible = 'on';
bode(L, opt); title('L con k = 1');
%observo que k debe ser 14 db

k = db2mag(14);
C = zpk(-p, 0, k);
L = minreal(C * P);
figure(3);
bode(L, opt); title('L final');

C_digi = c2d(C, Ts, 'tustin');

figure(3);
S = minreal(1/(1 + L));
bode(S, opt); title('S');

figure(4);
T = minreal(L/(1 + L));
bode(S, opt); title('T');

figure(5);
CS = minreal(C * S);
bode(CS, opt); title('CS');

figure(6);
PS = minreal(P * S);
bode(PS, opt), title('PS');