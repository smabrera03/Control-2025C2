s = tf('s');
P = (s - 1)*(s - 3) / (s-4) / (s-5);

SS = ss(P);
A = SS.A;
B = SS.B;
C = SS.C;
D = SS.D;

% ¿Es controlable?

Wr = [B A*B];
det(Wr); % != 0

%busco Wrm (Wr moño)
[num, den] = ss2tf(A, B, C, D);
a1 = den(2);
a2 = den(3);

Am = [-a1 -a2; 1 0];
Bm = [1; 0];

Wrm = [Bm Am*Bm];

%Wrm = inv([1 a1; 0 1]) ????'

%quiero los siguientes coeficientes:
p1 = 8;
p2 = 16;

K = [p1-a1 p2-a2] * Wrm * inv(Wr);

%todo esto equivale a K = acker(A, B, [-4 -4]). Me gusta complicarme


%%
Acl = A - B * K;

[ceros, polos, ganancia] = ss2zp(Acl, B, C, D);

L = zpk(ceros, polos, ganancia);

opt = bodeoptions;
opt.grid = 'On';
opt.PhaseMatching = 'On';
opt.PhaseMatchingFreq = 1;
opt.PhaseMatchingValue = -180;

bode(L, opt); title('Transferencia de lazo abierto compensada y sin acción integral');

%obs: cuando pongo la acción integral se desestabiliza. No entiendo por
%qué.
%Hay un cero de fase no mínima que me está arruinando la estabilidad. En el
%rootlocus se ve bien.

%Mi única opción para no tener error al seguir al escalón es poner el kf
%adecuado

Bcl = [0; 1];
Ccl = [C-D * K];

kf = -1/(Ccl * inv(Acl)*Bcl); %no me está dando bien. Revisar después
%%
%Acción integral, segundo intento

Aa = [A zeros(order(P), 1); -C 0];
Ba = [B; -D];

Ka = acker(Aa, Ba, [-4 -4 -100]);

K_nuevo = Ka(1:order(P));
ki = - Ka(end);

%CONTROLADO

%%
Afinal = Aa - Ba * Ka;
Bfinal = [zeros(order(P), 1); 1];
Cfinal = [C-D*K_nuevo, D*ki];
Dfinal = 0;

[z_final, p_final, k_final] = ss2zp(Afinal, Bfinal, Cfinal, Dfinal);

T = zpk(z_final, p_final, k_final);

bode(T, opt); title('Transferencia de lazo cerrado final');
