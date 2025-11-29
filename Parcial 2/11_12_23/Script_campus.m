clear all; close all; clc;

%Sistema linealizado
p1 = -628.3;
p2 = -0.936;
P = zpk([],[p1 p1 p1 p2 -p2],2.48e8);

% Separo en parte de fase minima y parte pasatodo
Pap = zpk(p2,-p2,1);
Pmp = zpk([],[p1 p1 p1 p2 p2],2.48e8);

% Configuración del Bode
my_bode_options = bodeoptions;
my_bode_options.PhaseMatching = 'on';
my_bode_options.PhaseMatchingFreq = 1;
my_bode_options.PhaseMatchingValue = -180;
my_bode_options.Grid = 'on';
my_bode_options.XLim = {[1 1e4]};

% Busco la minima Wgc, tal que el Pap reste 25° de fase, ya que
% los otros 5° los dejo para la parte correspondiente al control digital
Phase_pap = 25;
wgc = abs(p2)/tan(deg2rad(Phase_pap/2)); 

% Aproximacion de Pade para digitalizacion
Phase_dig = 5;    %Utilizo 5° para digitalizacion
Ts = 2*Phase_dig*pi/(180*wgc);
s = tf('s');
Pd = (1 - Ts/4 * s)/(1 + Ts/4 * s);

%Controlador
k = 1;
C = zpk([p1 p1 p1 p2 p2],[0 -1e3 -1e3 -1e3 -1e3],k); %Accion integral
figure();
bode(minreal(C*Pmp), my_bode_options);
title('Bode Lmp = C*Pmp con k=1');

%Ajusto ganancia para llevar wgc a 4.22 rad/seg 
k = db2mag(84.26);
C = zpk([p1 p1 p1 p2 p2],[0 -1e3 -1e3 -1e3 -1e3],k); %Accion integral
figure();
bode(minreal(C*P*Pd), my_bode_options);
title('Bode L = C*P con C digitalizado');