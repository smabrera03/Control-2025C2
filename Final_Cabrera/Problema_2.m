%%
%Problema 2: Compensación

clear all;close all;clc

s=tf('s');


Pap = zpk([50, 50, -1, -1], [-50, -50, 1, 1], 1);
Pmp = zpk([-50, -50], [-1, -1], 1);

optionss=bodeoptions;
optionss.MagVisible='off';
optionss.PhaseMatching='on';
optionss.PhaseMatchingValue=-180;
optionss.PhaseMatchingFreq=1;
optionss.Grid='on';

figure();bode(Pap,optionss,{.1,100}); title('Bode de Pap');
set(findall(gcf,'type','line'),'linewidth',2);

%Nota: en el bode de Pap observo que Pap nunca resta menos de 30°. Necesito
%una red de adelanto

%A mi controlador añado (s + 5)/(s + 50)

P = minreal(Pap * Pmp);

k = db2mag(31); %Esta ganancia fue ajustada luego de ver el bode de L
C = zpk([-1, -1, -5], [0, -50, -50, -50], k); %controlador con la red de adelanto

L = minreal(P * C);
% GRUPO DE LAS 4.
S = 1/(1+L);
T = 1-S;
PS = minreal(P*S);
CS = minreal(C*S);
% Bodes
optionss.MagVisible='on';
freqrange={10^-1,100};
figure();
h1=subplot(2,2,1);
bode(L,optionss,freqrange);title('L')

%En el bode de L observo que para tener MF 60° un valor posble para wgc es
%wgc = 5
%Para ello, necesito k = 31 dB

optionss.PhaseVisible='off';

h2=subplot(2,2,2);
bode(S,T,optionss,freqrange);title('S & T')

%En este bode observo el margen de estabilidad
%sm = 1/max(S) = 1/8db
sm = 1/db2mag(8.1)

h3=subplot(2,2,3);
bode(PS,optionss,freqrange);title('PS')
h4=subplot(2,2,4);
bode(CS,optionss,freqrange);title('CS')
set(findall(gcf,'type','line'),'linewidth',2);

figure();
time= 8;

%T es la transferencia de lazo cerrado.
%Esta es la respuesta ante un escalón en la entrada (en naranja)

h1=subplot(3,1,1);
step(S,T,time);title('S & T');grid on; legend();

%PS es la transferencia de la perturbación de entrada a la salida
%Esta es la respuesta ante un escalón en la perturbación de entrada
%Se observa que se rechaza

h2=subplot(3,1,2);
step(PS,time);title('PS');grid on

h3=subplot(3,1,3);
step(CS,time);title('CS');grid on
set(findall(gcf,'type','line'),'linewidth',2);
linkaxes([h1 h2 h3], 'x');


