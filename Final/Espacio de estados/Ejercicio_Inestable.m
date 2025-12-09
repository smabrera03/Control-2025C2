clear;

A = [100, 0; 160, 200];
B = [70; 160];
C = [1, 1];
D = 1;

G = ss(A, B, C, D);

[ceros, polos, gan] = ss2zp(A, B, C, D);

%% Realimentación de estados
% ¿Controlable?

Wr = [B, A * B];
det(Wr); % != 0 ==> Controlable

[num, den] = ss2tf(A, B, C, D);

%coeficientes que tengo
a1 = den(2);
a2 = den(3);

%coeficientes que quiero:
p1 = 2;
p2 = 1;

Wrm = inv([1, a1; 0, 1]);

K = [p1 - a1, p2 - a2] * Wrm * inv(Wr);

%igual a K = acker(A, B, [ -1, -1]);

kf = 1/(-(C - D*K) * inv(A - B*K) * B + D);


%% Agrego un observador

Wo = [C; C*A];
det(Wo); % ! = 0 ==> Controlable
Wom = inv([1, 0; a1, 1]);

l1 = 8;
l2 = 16;

L = inv(Wo) * Wom * [l1 - a1; l2 - a2];

%equivale a L = (acker(A', C', [-4 -4]))'
%La tilde ' transpone las matrices


%% ¿Regulador?

rsys = reg(G, K, L);

%hay que volver a ajustar kf, no sé cómo
[ceros_controlador, polos_controlador, gan_controlador] = ss2zp(rsys.A, rsys.B, rsys.C, rsys.D);
Controlador = zpk(ceros_controlador, polos_controlador, gan_controlador);
Planta = zpk(ceros, polos, gan);

Lazo = minreal(Controlador * Planta);

Lazo_cerrado = minreal( Lazo/(1 + Lazo) );
% ¿y ahora me da insteable?????


%%
%agrego acción integral

Aa = [A, [0;0]; -C, 0];
Ba = [B; -D];

Ka = acker(Aa, Ba, [-1 -1 -1]);

K_nuevo = Ka(1:2);
ki = - Ka(end);

%%
%agrego observador



