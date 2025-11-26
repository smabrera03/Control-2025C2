%%
s = tf('s');
Pap = (s + 1)*(s + 10)/( (s - 1)*(s - 10));

Pmp = 10/((s+1) * (s+10));

Ts = 0.8e-3;
pade = (1 - Ts/4 * s)/(1 + Ts/4 * s);

P = minreal(Pmp * pade);

k = db2mag(134);
C1 = k/s * (s+1)^2/(s+1000)^2; %control integral y red de adelanto de segundo orden

Cmp1 = minreal(C1 * Pmp);

L = minreal(C1 * P);

S = 1/(1 + L);
T = L/(1 + L);

CS = minreal(C1 * S);
PS = minreal(P * S);

opt = bodeoptions;
opt.PhaseMatching = 'on';
opt.PhaseMatchingFreq = 1;
opt.PhaseMatchingValue = -180;
opt.Grid = 'on';


%% Bode de Pap y pade
opt.MagVisible = 'off';
bode(Pap, pade, opt, {10, 1000});
legend();
title('Fase de Pap y pade');


%% Bode de Pmp y Cmp1
opt.MagVisible = 'off';
bode(Pmp, Cmp1, opt);
legend();
title('Fases de Pmp y Cmp1');

%% Bode de L
figure(1);
opt.MagVisible = 'on';
bode(L, opt);
title('Bode de L');

%es estable!!!!!!!

figure(2);
margin(L, opt);grid On;
%%

systems = {S, T, CS, PS};
names   = {'S', 'T', 'CS', 'PS'};

for k = 1:4
    subplot(2,2,k);

    % Crear un bodeplot dentro del subplot
    h = bodeplot(systems{k}, opt, {1, 10000});
    
    % Forzar a que se dibuje dentro del subplot actual
    setoptions(h, opt);
    grid on;

    title(['Bode de ', names{k}]);
end

%%

figure;
subplot(2, 1, 1);
step(T); grid On;
title('Rta al escalón de entrada');

subplot(2, 1, 2);
step(PS); grid On;
title('Rta al escalón de perturbación');
