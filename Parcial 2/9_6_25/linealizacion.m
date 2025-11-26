%% Linealización
syms x1 x2 x3 u y;

p = 1000;
alfa = (4/pi)^3 * 1/sqrt(2);


%% Pruebo un par de cosas
f(x1, u) = - p*x1 - p * u; % <-- función simbólica
g = -p * x1 - p * u;       % <-- expresión simbólica

class(f); % devuelve ´symfun'
class(g)  % devuelve 'sym'

%% Sigo con el ejercico en serio

x = [x1; x2; x3];
f1 = -p * x1 + p * u;
f2 = x3;
f3 = -alfa * x2^3 + sin(x2) - x3 + x1;
f = [f1; f2; f3];

y = x2;
%ojo: son todas EXPRESIONES simbólicas

%declaro los puntos de equilibrio
x1e = 0;
x2e = pi/4;
x3e = 0;
ue = 0;
ye = pi/4;

jacA = jacobian(f, x);
jacB = jacobian(f, u);
jacC = jacobian(y, x); %class(jacC) = 'sym'
jacD = jacobian(y, u);

A = subs(jacA, {x1, x2, x3}, {x1e, x2e, x3e}); % class(A) = 'sym'
A = double(A); %class(A) = 'double'

B = subs(jacB, {u}, {ue});
B = double(B);

C = subs(jacC, {x1, x2, x3}, {x1e, x2e, x3e});
C = double(C);

D = subs(jacD, {u}, {ue});
D = double(D);

%paso a tf:
[ceros, polos, K] = ss2zp(A, B, C, D);

sistema = ss(A, B, C, D);
P = tf(sistema);

%% El código de cata:

syms x1 x2 x3 u y;

x = [x1; x2; x3];
y = x2;

p = 1000;
alfa = (4/pi)^3 * 1/sqrt(2);

f1 = -p*x1 + p*u;
f2 = x3;
f3 = -alfa*x2^3 + sin(x2) - x3 + x1;
f = [f1; f2; f3];

A = jacobian(f, x);
B = jacobian(f, u);
C = jacobian(y, x);
D = jacobian(y, u);

% equilibrio
x1e = 0;
x2e = pi/4;
x3e = 0;
ue  = 0;
ye  = pi/4;

A = subs(A, str2sym({'x1','x2','x3','u','y'}), {x1e, x2e, x3e, ue, ye});
B = subs(B, str2sym({'x1','x2','x3','u','y'}), {x1e, x2e, x3e, ue, ye});
C = subs(C, str2sym({'x1','x2','x3','u','y'}), {x1e, x2e, x3e, ue, ye});
D = subs(D, str2sym({'x1','x2','x3','u','y'}), {x1e, x2e, x3e, ue, ye});

A_eq = double(A);
B_eq = double(B);
C_eq = double(C);
D_eq = double(D);

[Num, Den] = ss2tf(A_eq, B_eq, C_eq, D_eq);

P = zpk(ss(A_eq, B_eq, C_eq, D_eq));

[ceros, polos, K] = ss2zp(A_eq, B_eq, C_eq, D_eq);
