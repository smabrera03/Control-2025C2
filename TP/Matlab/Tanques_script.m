%dx/dt = f(x, u)
%y = g(x, u)
%Creo variables simbólicas
%Las variables simbólicas no tienen un valor númerico. Representan
%variables matemáticas. Sobre las variables simbólicas se pueden definir
%funcionas, las cuales se pueden derivar, integrar, calcular jacobianos etc
%como lo harías a mano.
syms x1 x2 u1 u2

%Defino f:
f = [-sqrt(x1 - x2) + u1;
            sqrt(x1 - x2) - sqrt(x2) + u2];

J_A = jacobian(f, [x1, x2]);
A = subs(J_A, {x1, x2, u1},{2, 1, 1}) %substituye las variables simbólicas por valores numéricos
        
J_B = jacobian(f, [u1]);
B = subs(J_B, u1, 1)

%defino g
g = sqrt(x2);

J_C = jacobian(g, [x1, x2]);
subs(J_C, {x1, x2}, {2, 1})

J_D = jacobian(g, [u1 u2]);
subs(J_D, {u1, u2}, {1, 0})
