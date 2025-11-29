s = tf('s');

z = 100.0;
wgc = 10;

Pmp = (s + z)^3/(s + 1)^3;
%Pmp = minreal(Pmp * Pmp * Pmp);

Pap = ((s + 1)^3 * (z - s)^3)/((s - 1)^3 * (s + z)^3);
%Pap = minreal(Pap);

P = minreal(Pmp * Pap, 0.1); %OJO CON ESTA TOLERANCIA, PUEDE ROMPER LAS PELOTAS

%%
opt = bodeoptions();
opt.grid = 'On';
opt.MagVisible = 'off';
opt.PhaseMatching = 'On';
opt.PhaseMatchingValue = -180;
opt.PhaseMatchingFreq = 1;

bode(Pap, opt);
title('Bode Pap');


%%
%observo que me quedé corto. Busco un nuevo z (ver xournal)

z = tan(pi/4 * 1/12)^(-2); % 232.7776

wgc = sqrt(z);

Pmp = (s + z)^3/(s + 1)^3;
Pap = ((s + 1)^3 * (z - s)^3)/((s - 1)^3 * (s + z)^3);
P = minreal(Pmp * Pap, 0.1);

bode(Pap, opt);
title('Bode Pap');

%%
%Parte 2: estabilizar
%bode de Pmp
opt.MagVisible = 'on';
bode(Pmp, opt); title('Bode Pmp');

%obs: resta mucha fase en wgc. Debo cancelar el polo triple en -1

%%
k = db2mag(-26.5);
p = 200;
C = k/s * (s+1)^3/(s + p)^2;

CPmp = minreal(C * Pmp, 0.1);

figure();
bode(CPmp, opt); title('C + Pmp');

L = minreal(C * Pmp * Pap, 0.1);
figure();
bode(L, opt);title('Bode de L'); %acá observo que k = -26.5 dB para que wgc = 15

T = minreal(L/(1 + L), 0.1);