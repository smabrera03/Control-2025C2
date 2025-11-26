%%
close all; clear; clc;

s = tf('s');

Pmp = 1/( (s+2)^2 * (s + 20)^2);
Pap = (s+2)*(s+20)/((s-2)*(s-20));

Ts = 0.001;
pade = zpk([4/Ts], [-4/Ts], -1);


P = minreal(Pmp * Pap * pade);

k = db2mag(220);
C = k * (s + 10)/s * (s + 2)^3/(s + 1000)^3;
L = minreal(C * P);

Cmp = minreal(C * Pmp);
wmin = 0.1;
wmax = 4/Ts * 10;

opt = bodeoptions();
opt.PhaseMatching = 'on';
opt.PhaseMatchingValue = -180;
opt.PhaseMatchingFreq = 1;
opt.grid = 'On';


%% Fase del padé
opt.MagVisible = 'off';
opt.PhaseMatchingValue = -180;
opt.PhaseMatchingFreq = 1;
bode(pade, opt);
title('Fase del padé');
%%

%%Fase de Pap
figure();
bode(Pap, pade, opt);
legend();
title('Fase del Pap');

figure();
bode(Pap * pade, opt);
title('Pap y padé');

%% Fase de la planta
opt.MagVisible = 'On';
bode(P, opt);
title('Fase de P');

%% Cmp
opt.MagVisible = 'on';
bode(Cmp, Pap * pade, opt);
legend();
title('Cmp');
%% Modulo de L
opt.MagVisible = 'on';
opt.grid = 'on';
bode(L, opt);
title('L');

%% Sensibilidad
S = 1/(1 + L);
bode(S, opt);
title('S');


%%
figure(1);
T = minreal(L/(1 + L));
step(T); grid On;
title('Salida del escalón');

figure(2);
S = 1/(1 + L);
CS = minreal(C * S);
step(CS); grid On;
title('Acción de control');

