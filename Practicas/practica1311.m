%%
%me olvidé el cable de la tablet
%Queremos MF = 60 con control integral propio
% ¿cuál será la planta no?
%El diagrama de ñacuis
close all;
clear;
clc;

s = tf('s');
tau = 0.01;
P = exp(-tau*s);

figure;
bode(P, {1, 10});
grid On

figure;
P_aprox = (1 - tau/2 * s)/(1 + tau/2 * s) * exp(2*pi*1i);
bode(P_aprox, P, {0.1, 100});
grid On;
legend;
%la aproximación vale para tau chicos

%{

Limitación de diseño:

wc < tan (15°) * z

z: cero de la transferencia del retardo
wc: frecuencia de cruce de los 0 dB

%}

%%
clc;
clear;
close all;

s = tf('s')
p = 1;
PAP = (s + p)/(s - p);

bode(PAP);
grid On

%{

Esta es la parte PAP del sistema. Si el sistema global tiene frecuencia de
corrte wc, a esa frecuencia la parte PAP pone el siguiente retardo:

                    -2 atan(p/wc) >= - 30°
¿De dónde sale la desigualdad?

Despejando wc te queda

wc >= p / tg(15°)

Combinandolo con lo de antes

    p/tg(15°) <= wc <= tg(15°) * z

( tg(15°) < 1 )
--> wc debe estar por arriba del polo y por debajo del cero
--> Si el polo está por encima del cero no se puede resolver
%}
%%