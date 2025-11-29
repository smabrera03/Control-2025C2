clear; close all; clc;

%defino los valores de eq
ue = 1/2;
ye = pi/6;
x1e = pi/6;
x2e = 0;

opt = bodeoptions;
opt.PhaseMatching = 'on';
opt.PhaseMatchingValue = -180;
opt.PhaseMatchingFreq = 1;
opt.grid = 'on';

wn = sqrt(sqrt(3/4));
p = 0 + i *wn; 

P = zpk([], [-p, -conj(p)], 1);

k = db2mag(100);
C = zpk([-wn -wn], [ 0 -100 -100], k);

figure();
L = minreal(C * P);
bode(L, opt); title('L');
%observo que k = 60db me da wgc = 10

% Ts < 4/wgc * tan(phi_digi/2)
%elijo phi_digi = 5° --> Ts < 0.017
Ts = 0.01;
C_digi = c2d(C, Ts, 'tustin');