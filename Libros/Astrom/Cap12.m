%%
s = tf('s');

L = (s+1)^(-2) * s^(-2);

S = 1/(1+L);

T = L/(1+L);

display(S);

figure;
bodemag(L);
grid On;
legend;

%%
%Redes de adelanto y atraso
s = tf('s');
C_adelanto = 10 * (s+1)/(s+100); %adelanto a < b
C_atraso = 0.1* (s + 100)/(s+1); %atraso b < a

bode(C_atraso, C_adelanto);
grid On;
legend;

%%
%controlar una planta con red de atraso
clear;
close all;
clc;

s = tf('s');
P = 3* (s + 1) / (s + 10);
k = 0.319;
C = k * (s + 10)/s;
L = C * P;
S = 1/(1 + L);
T = L/(1 + L);

figure;
margin(P);

figure;
nyqlog(P);

figure;
margin(L);
grid On;
legend;

figure;
nyqlog(L);

%%
%Ejemplo 12.5 AyM
clear;
clc;
close all;

s = tf('s');
r = 0.25;
J = 0.0475;

P = r/(J*s^2);cl

C = 200 * (s + 2)/(s + 50);

figure;
nyqlog(P);
title('Nyquist de la planta');

figure;
nyqlog(C * P);
title('Nyquist del lazo');


%%
clc;
clear;
close all;

s = tf('s');

P = 1/s;

kp = 1000;
ks = kp * 10000;

z1 = 0.4;
z2 = 0.2;
z3 = 0.05;

w0 = 1000;

C1 = kp + ks * s/(s^2 + 2*z1*w0*s + w0^2);
C2 = kp + ks * s/(s^2 + 2*z2*w0*s + w0^2);
C3 = kp + ks * s/(s^2 + 2*z3*w0*s + w0^2);

L1 = P * C1;
L2 = P * C2;
L3 = P * C3;

T1 = L1/(1 + L1);
T2 = L2/(1 + L2);
T3 = L3/(1 + L3);

figure;
bodemag(T1, T2, T3, {10, 1e4});
grid on;

leyendas = {sprintf('z1 = %.2f', z1), 
    sprintf('z2 = %.2f', z2),
    sprintf('z3 = %.2f', z3)
    };
legend(leyendas, 'Location', 'southwest');


%%