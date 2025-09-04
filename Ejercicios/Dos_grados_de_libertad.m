b = [0 0 0 0.5];
a = [1 0.5 1.5 0.25 0];
G = tf(b, a);
t = [0: 0.001: 10];
%nota: la sintaxis es t_ini: tasa_de_muestreo: t_fin
%step(G, t);
%grid

%impulse(G, t);

[A, B, C, D] = tf2ss(b, a);
%Na que ver
H = ss2tf(A, B, C, D);
%No es la misma transferencia. Raro
[z, p, k] = tf2zpk(b, a)
roots(a)
