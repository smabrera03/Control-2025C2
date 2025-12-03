s = tf('s');

k = 0.1 * 0.2; %ganancia para que tenga ganancia 1 en continua
P = ss (zpk(  k/((s + 0.1) * (s + 0.2))  )) ;

A = P.a;
B = P.b;
C = P.c;
D = P.d;

step(P); grid('on');

%Mi problema es que P así como está es muy lenta. Quisiera hacerla más
%rápida

% ¿Es controlable este sistema?

Wr = [B A*B];
det(Wr); % != 0 ==> Controlable
 [num, den] = ss2tf(A, B, C, D);
 
 a1 = den(2);
 a2 = den(3);
 
 %Matrices de la forma canóncia controlable
 Am = [-a1 -a2; 1 0];
 Bm = [1; 0];
 
 %Matriz de controlabilidad en forma canónica:
 Wrm = [Bm Am*Bm];
 
 %polos que quiero:
 polo1 = -10;
 polo2 = -20;
 

% (s + 10)*(s + 20) = s^2 + 30*s + 200

%coeficientes que quiero en el polinomio del sistema:
p1 = 30;
p2 = 200;

 %fórmula de Ackermann:
 K = [p1-a1 p2-a2] * Wrm * inv(Wr);
 
K_acker = acker(A, B, [polo1 polo2]);

kf = -1/(C*inv(A - B*K) * B); %ganancia de feedforward