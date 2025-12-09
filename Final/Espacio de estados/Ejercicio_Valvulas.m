%%
% linealización

syms x1 x2 x3 y u;

x = [x1; x2; x3];

f1 = - sqrt(x1 - x2) + 5 * 40^(x3 - 1);
f2 = sqrt(x1 - x2) - sqrt(x2);
f3 = -x3 + u;
f = [f1; f2; f3];

y = x1;

x1e = 2;
x2e = 1;
x3e = log(1/5)/log(40) + 1;

xe = [x1e; x2e; x3e];

ue = x3e;
ye = x1e;

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


[ceros, polos, ganancia] = ss2zp(A, B, C, D);

sistema = ss(A, B, C, D);
P = tf(sistema);

%%
% Realimentación de estados
%Vector K

Aa = [A, zeros(size(B)); -C, 0];
Ba = [B; 0]; 
Ca = [C, 0];
%¿Cóntrolable?

Wr = [Ba, Aa * Ba, Aa^2 * Ba, Aa^3 * Ba];
det(Wr); % != 0 ==> Controlable

Ka = acker(Aa, Ba, [-1 -1 -1 -1]);

K = Ka(1:order(P));
ki = - Ka(end);


%%
%observador

Wo = [C; C*A; C*A^2];
det(Wo); % == 0 ==> NO OBSERVABLE. CHANFLE

