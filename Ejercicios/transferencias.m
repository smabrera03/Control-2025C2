Pol = [32 8 49];
disp('hola mundo')
disp('P es el polinomio de coeficientes: ')
disp(Pol)
%esto es un comentario

%{

Esto también es un comentario, pero más largo

%}

%%% Punto i)
num1 = [32 8 49];
den1 = [1 2 1];

[r, p, k] = residue(num1, den1);

%{
Nota sobre la función residue: si tenes un polo de multiplicidad mayor a 1,
te devuelve los residuos en orden ascendente
%}

num2 = [1 3];
den2 = poly([-2, -1, -1]);
[r, p, k] = residue(num2, den2);

'G1(s)'

G1 = tf(num1, den1)

G2 = tf(num2, den2)
%step(G1)
step(G2)
grid

