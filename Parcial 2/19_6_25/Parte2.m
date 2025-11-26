%% Problema 5 Practica:
%%
clear all;close all;clc
s = tf('s');
Ts = 0.01;
Pap=zpk([4/Ts, -2],[-4/Ts, 2],-1);
Pmp = zpk(1/( (s + 2)^2 * (s^2 + 20^2) ))
optionss = bodeoptions;
optionss.MagVisible = 'off';
optionss.PhaseMatching = 'on';
optionss.PhaseMatchingValue = -180;
optionss.PhaseMatchingFreq = 1;
optionss.Grid = 'on';

wmin = 0.1;
wmax = 4/Ts * 10;
figure();bode(Pap,optionss,{wmin,wmax});
title('Bode de Pap')
set(findall(gcf,'type','line'),'linewidth',2);
P=minreal(Pap*Pmp);

%%
%C=db2mag(4)*(s+.25)/s;
close all;clc
k = db2mag(100);
C = k/s * (s + 20)^2 /(s + 200);
L = minreal(P*C);
% GRUPO DE LAS 4.
S = 1/(1+L);
T = 1-S;
PS = minreal(P*S);
CS = minreal(C*S);
% Bodes
optionss.MagVisible = 'on';
freqrange = {wmin,wmax};
figure();
h1 = subplot(2,2,1);
bode(L,optionss,freqrange);title('L')
optionss.PhaseVisible = 'off';
h2 = subplot(2,2,2);
bode(S,T,optionss,freqrange);title('S & T')
h3 = subplot(2,2,3);
bode(PS,optionss,freqrange);title('PS')
h4 = subplot(2,2,4);
bode(CS,optionss,freqrange);title('CS')
set(findall(gcf,'type','line'),'linewidth',2);

%%

figure();
optionss.PhaseVisible = 'on';
optionss.PhaseMatchingValue = -180;
optionss.PhaseMatchingFreq = 1;
bode(L,optionss,freqrange);
title('L');
set(findall(gcf,'type','line'),'linewidth',2);

figure();
optionss.PhaseMatchingValue = 0;
optionss.PhaseMatchingFreq = 1;
bode(T, optionss, freqrange);
title('T')
set(findall(gcf,'type','line'),'linewidth',2);


%%

figure();
optionss.PhaseVisible = 'on';
optionss.PhaseMatchingValue = -180;
optionss.PhaseMatchingFreq = 1;
bode(S,optionss,freqrange);
title('S');
set(findall(gcf,'type','line'),'linewidth',2);

%%

close all;clc
figure();
time= 1; %tiempo final
h1=subplot(3,1,1);
step(S,T,time);title('S & T');grid on;legend();
h2=subplot(3,1,2);
step(PS,time);title('PS');grid on
h3=subplot(3,1,3);
step(CS,time);title('CS');grid on
set(findall(gcf,'type','line'),'linewidth',2);
linkaxes([h1 h2 h3], 'x');

%%