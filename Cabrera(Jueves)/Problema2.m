clear; close all, clc;
%{ 
punto a)

Reemplazo los valores de equilibrio en la ecuación de la dinámica y despejo
alfa. En el punto de equilibrio las derivadas se anulan.

alfa = 6/pi * sin(pi/6) = 0.9549

%}

alfa = 6/pi * sin(pi/6);

%{
Punto b)

Si thita = 0, el sistema está siempre en equilibrio, cualquiera sea el
valor de alfa
%}

%{
Punto c)
Despejo tau_b de la ecuación de la dinámica:

tau_b = alfa * pi/4 - sin(pi/4) = 0.0492

Para hallar u_b que produce tau_b necesito saber la gananica en continua (w = 0) de la
transferencia T(s) / U(s)

T(0) / U(0) = 1

Entonces: u_b = tau_b
%}

tau_b = alfa * pi/4 - sin(pi/4);
u_b = tau_b;

%{
Punto d)

La entrada de mi sistema será u. La salida será thita.

Las variables de estado son:
x1 = thita
x2 = thita_punto
x3 = tau
x4 = tau_punto

Para obtener las 4 ecuaciones del sistema reescribo la transferencia T(s) /
U(s) como:

(s^2 + s * zeta * wn * s + wn^2) * T(s) = wn^2 * U(s)

Anti-transformo y despejo x4_punto (derivada segunda de tau)
Entonces:
x4_punto = -wn^2 * x3 - 2*zeta*wn *x4 + wn^2 * u

Finalmente, la representación en espacio de estados del sistema es:

x1_punto = x2
x2_punto = -alfa * x1 + sin(x1) - x2 + x3
x3_punto = x4
x4_punto = -wn^2 * x3 - 2*zeta*wn *x4 + wn^2 * u

%}

%{
Punto e)
Linealizo
%}

syms x1 x2 x3 x4 u y;

x = [x1; x2; x3; x4];

y = x1;

%No hay datos para wn ni zeta. Elijo que la transferencia T/U sean 2 polos
%reales en 100. zeta = 1, wn = 100.

%NOTA: cuando llegó el profesor Sellerio aclaró los valores de wn y zeta,
%pero también aclaró que si ya habíamos elegido valores podíamos
%quedarnos con esos.

wn = 100;
zeta = 1;

%defino la dinámica
f1 = x2;
f2 = -alfa * x1 + sin(x1) - x2 + x3;
f3 = x4;
f4 = -wn^2 * x3 - 2*zeta*wn *x4 + wn^2 * u;

f = [f1; f2; f3; f4];

%defino los puntos de equilibrio:
x1e = pi/4;
x2e = 0;
x3e = tau_b;
x4e = 0;
ue = tau_b;
ye = x1e;

xe = [x1e; x2e; x3e; x4e];

A=jacobian(f,x);
B=jacobian(f,u);

C = [1 0 0 0 ];
D= [0];
%No hace falta hacer el jacobiano porque esta parte del problema ya es
%lineal

A = subs(A, x, xe);
B = subs(B, u ,ue);
A = double(A);
B = double(B);

P = zpk(ss(A,B,C,D));

%Observo que la transferencia P es estable


%Punto f
%Propongo el siguiente controlador, con acción integral, un polo en el
%origen, un cero doble en -1/2 para compensar los polos de la planta y un
%polo doble en -100 para hacerlo estrictamente propio:

k = db2mag(0);
C = zpk([-1/2 -1/2], [0 -100 -100], k);

L = minreal(C * P);

opt=bodeoptions;
opt.PhaseMatching='on';
opt.PhaseMatchingValue=-180;
opt.PhaseMatchingFreq=1;
opt.Grid='on';

bode(L, opt); title('L con (k = 1)');
%Quiero wgc = 1. Necesito k = 100 dB
k = db2mag(100);
C = zpk([-1/2 -1/2], [0 -100 -100], k);

L = minreal(C * P);
bode(L, opt); title('Bode final de L');

T = minreal(L/(1 + L));

pole(T)
%Se observa que todos los polos de T tienen parte real negativa, el sistema
%es estable
