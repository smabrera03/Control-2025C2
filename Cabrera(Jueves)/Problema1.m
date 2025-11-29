%%
clear all;close all;clc
s = tf('s');

Pap = zpk([-20 -100],[20 100], 1);
Pmp = zpk([], [-20 -100], 2000);

opt=bodeoptions;
opt.MagVisible='off';
opt.PhaseMatching='on';
opt.PhaseMatchingValue=-180;
opt.PhaseMatchingFreq=100;
opt.Grid='on';

P = Pap * Pmp;
figure();
bode(Pap,opt,{1, 10000}); title('Fase de Pap');
set(findall(gcf,'type','line'),'linewidth',2);
P = minreal(Pap*Pmp);

%propongo el siguiente compensador
k = db2mag(0); % en principio k = 1, luego ajusto la ganancia para el wgc que quiero
C = zpk([-20 -100], [0 -10000 -10000], k);

%agrego el retardo de Pade:
Ts = 1e-4;
pade = zpk(4/Ts, -4/Ts, -1);

L = minreal(P * C * pade);

opt.MagVisible = 'on';
figure();
bode(L, opt, {1e2, 1e4});title ('Bode de L (k = 1)');
%observo que para que wgc = 1.000, k debe ser 154dB
k = db2mag(154);
%Nota: el valor calculado en la aprte escrita no era correcto

C = zpk([-20 -100], [0 -10000 -10000], k);
L = minreal(C * P * pade);
figure();
bode(L, opt, {1e1, 1e5}); title('Bode final de L');

% GRUPO DE LAS 4.
S = minreal(1/(1+L));
T=1-S;
PS=minreal(P*S);
CS=minreal(C*S);
% Bodes
opt.MagVisible='on';
freqrange={1, 10000};
%4 respuestas en frecuencia de interés
figure();
h1=subplot(2,2,1);
bode(L,opt,freqrange);title('L')
opt.PhaseVisible='off';
h2=subplot(2,2,2);
bode(S,T,opt,freqrange);title('S &amp; T')
legend();
h3=subplot(2,2,3);
bode(PS,opt,freqrange);title('PS')
h4=subplot(2,2,4);
bode(CS,opt,freqrange);title('CS')
set(findall(gcf,'type','line'),'linewidth',2);

%respuestas al escalón
figure();
time= 1 ;
h1=subplot(3,1,1);
%respuesta del error al escalón de referencia
%y respuesta de la salida al escalón de referencia
step(S,T,time);title('S &amp; T');grid on
legend();
h2=subplot(3,1,2);

%respuesta de la salida a la perturnación de entrada
step(PS,time);title('PS');grid on
h3=subplot(3,1,3);

%respuesta de la acción de control al escalón de referencia
step(CS,time);title('CS');grid on
set(findall(gcf,'type','line'),'linewidth',2);
linkaxes([h1 h2 h3], 'x');
