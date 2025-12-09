%%
% Mi sistema original en FCO es:
A = [-2 1; -1 0];
B = [1; 0];
C = [1 0];
D = 0;

[Z, P, K] = ss2zp(A, B, C, D);
Planta = minreal(zpk(Z, P, K));

% A mano diseñé el vector L (ver Observabilida.m):

L = [18; 99];
eig(A - L*C) %polos del observador

%%
% Ahora tengo que diseñar el vector de ganancias K. Quiero polo doble en
% -10

K = acker(A, B, [-10 -10]);
%sospechosamente similar a L
%OJO: con esto muevo los polos del sistema de lazo ABIERTO
%es decir, si pongo un polo en 0 NO tengo acción integral. Acción integral
%es tener un polo en 0 en la transferencia de lazo CERRADO
%justo en este caso, si pongo un polo en 0 tengo acción integral, pero es
%una casualidad
kf = 10;

Acl = [A-B*K B*K; 0*eye(2) A-L*C];
Bcl = [kf*B; 0; 0];
Ccl = [C 0 0];
Dcl = 0;
Ccl * inv(Acl) * Bcl; % = 0
%kf = -1/(Ccl * inv(Acl) * Bcl); %No puedo hacer esta cuenta

[Z, P, k] = ss2zp(Acl, Bcl, Ccl, Dcl);

T = minreal(zpk(Z, P, k));

L_ol = minreal(T/(1-T));

bode(Planta, L_ol, T); grid On;
legend();

%La transferencia de T es exactamente igual a la de Planta, pero con los
%polos corridos