%%
%Problema 3

clear all;close all;clc
orden=3 ;
x=sym('x',[orden 1],'real');
u=sym('u','real');

p = 0.02;
f1 = (-sqrt(x(1) - x(2)) + x(3) )/x(1)^2;
f2 = (sqrt( x(1) - x(2) ) - sqrt( x(2)) )/x(2)^2;
f3 = -p * x(3) + p * u;
f=[f1; f2; f3];

A=jacobian(f,x);
B=jacobian(f,u);
C=[0, 1, 0];
D= 0;
x0= [2, 1, 1];
u0= 1;
y0= 1;


A = subs(A,{'x1', 'x2', 'x3'},{x0(1), x0(2), x0(3)});
B = subs(B,{'x1', 'x2', 'x3'},{x0(1), x0(2), x0(3)});
A = double(A);
B = double(B);


[ceros, polos, gan] = ss2zp(A, B, C, D);
P = zpk(ceros, polos, gan);

Ts = 0.5;

k = db2mag(24); %Este k fue ajustado luego de ver el bode de L
C = zpk([polos(1), polos(3)], [0, -1, -1], k);

Pade = zpk([4/Ts], [-4/Ts], -1);

L = minreal(C * P * Pade);

opt=bodeoptions;
opt.MagVisible='on';
opt.PhaseMatching='on';
opt.PhaseMatchingValue=-180;
opt.PhaseMatchingFreq=1;
opt.Grid='on';

figure(); bode(L, opt, {0.001, 10}); title('Bode de L');
%wgc = 0.04. MF = 90°.
%Elegí un k relativamente chico para que no se dispare la acción de
%control. El único problema es que la respuesta es algo lenta

T = minreal(L/(1 + L));
figure(); step(T); title('Respuesta al escalón'); grid On;
%Se comprueba que no hay sobrepico

S = 1/(1+L);
T = 1-S;
PS = minreal(Pade * P * S);
CS = minreal(C*S);

opt.MagVisible='on';
freqrange={10^-2,10};
figure();
h1=subplot(2,2,1);
bode(L,opt,freqrange);title('L')
opt.PhaseVisible='off';

h2=subplot(2,2,2);
bode(S,T,opt,freqrange);title('S & T')
%observo que sm = 1/db2mag(0.84) = 0.97 < 6 dB
h3=subplot(2,2,3);
bode(PS,opt,freqrange);title('PS')
h4=subplot(2,2,4);
bode(CS,opt,freqrange);title('CS')
set(findall(gcf,'type','line'),'linewidth',2);

%respuestas al esaclón
figure();
time= 50;
h1=subplot(3,1,1);
step(S,T,time);title('S & T');grid on; legend();

h2=subplot(3,1,2);
step(PS,time);title('PS');grid on

h3=subplot(3,1,3);
step(CS,time);title('CS');grid on
set(findall(gcf,'type','line'),'linewidth',2);
linkaxes([h1 h2 h3], 'x');

C_dig = c2d(C, Ts, 'tustin');

%Ver el archivo 'TamplateNoLineal' para ver la simulación

%%
%Problema 4;
C = [0, 1, 0];

Aa=[A zeros(order(P),1);-C 0]
Ba=[B;-D]
Ka=acker(Aa,Ba,[-1, -1, -1, -1])
K=Ka(1:order(P));
kI=-Ka(end);

%ver el acrchivo 'Problema_4.slx' para ver la simulación