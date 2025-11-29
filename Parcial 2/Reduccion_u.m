%malardo el ejemplo de marcelo
clear all; close all; clc;
set(0,'DefaultFigureWindowStyle','docked')

opt = bodeoptions;
opt.PhaseMatching = 'on';
opt.PhaseMatchingValue = -180;
opt.PhaseMatchingFreq = 1;
opt.Grid = 'on';
opt.XLim = {[0.1 1e3]};

P = zpk([], [5, -1, -10], 1);
Pmp = zpk([], [-5, -1, -10], 1);
Pap = zpk(-5, 5, 1);

figure();
opt.MagVisible = 'off';
bode(Pap, opt); title('Fase Pap');
%wgc = 20 es una opción viable

%M. propuso este controlador para wgc = 100:
km = db2mag(160);
Cm = zpk([-1 -5 -10], [0 -1e3 -1e3], km);

figure();
opt.MagVisible = 'on';
bode(minreal(Cm * P), opt); title('L según M.');

%A M. le queda la siguiente acción de control:
CSm = minreal(feedback(Cm, P));
figure();
t = 0.1;
step(CSm, t); title('Acción de control ante el escalón según M.');
%observo un pico en 1e8 ( == km)

%Yo propongo este controlador:
k = db2mag(118);
C = zpk([-1 -5 -10], [0 -200 -200], k);
%Criterio: Cancelo todos los ceros de Pmp que estén antes de wgc o muy
%cerca. Agrego polos para hacerlo propio, pero tan chicos como sea posible

figure();
bode(minreal(C * P), opt); title('Mi L');
%observo que k = 118dB

%mi acción de control
CS = minreal(feedback(C, P));
figure();
step(CS, t); title('Mi acción de control');
% observo un pico en 8e5 ( == k). Casi 2 órdenes de magnitud menos que antes.
% Igual es una banda

%propongo otro controlador
k2 = db2mag(98);
C2 = zpk([-1 -5 -10 -2000], [0 -200 -200 -200], k2); %nuevo cero en 2000 y nuevo polo en 200
figure();
bode(minreal(C2 * P), opt); title('Mi L2');
%observo k2 = 98 dB (20 db menos que antes)

CS2 = minreal(feedback(C2, P));
figure();
step(CS2, t); title('Acción de control 2');
%pico en 2e5. k2 bajó una decada respecto de k, pero el máximo no

%Tercer controlador: alejo aún más el cero
k3 = db2mag(-21.8);
C3 = zpk([-1 -5 -10 -2e9], [0 -200 -200 -200], k3); %nuevo cero en 2e9 y nuevo polo en 200
figure();
bode(minreal(C3 * P), opt); title('Mi L3');
%observo k3 = -21.8 dB 

CS3 = minreal(feedback(C3, P));
figure();
step(CS3, t); title('Acción de control 3');
%YA NO BAJA LA ACCIÓN DE CONTROL. LOCO
%agregar un cero sirve hasta ahí

%otra opción sería bajar wgc a costa de un peor margen de fase

%cuarta opción: agregar un polo y un cero ANTES de wgc
%para añadir ganancia, el cero debe estar antes que el polo
k4 = db2mag(164);
C4 = zpk([-1 -5 -10 -0.1], [0 -1 -200 -200 -200], k4); %nuevo polo en 1 y nuevo cero en 0.1
figure();
bode(minreal(C4 * P), opt); title('Mi L4');
%observo k4 = 164 dB 

CS4 = minreal(feedback(C4, P));
figure();
step(CS4, t); title('Acción de control 3');

%no tiene gracia xq el cero en 0.1 me quita ganancia así como el cero en
%2e9 me da ganancia

%otra: sacar el control integral

%otra: agregar una red de adelanto a frecuencias bajas, de manera tal que
%pueda poner wgc en por ejemplo 1 rad/s
%podría darle vueltas a esto todo el día