clear all;clc
s=tf('s');
P=zpk(((1000-s)/(1-s))^2);
Pmp=zpk( ( (1000+s) / (1+s) )^2 );
Pap1=zpk( (1000-s)/(1000+s) )^2; % Debida al cero de NMP
Pap2=zpk(((s+1)/(s-1)))^2;         % Debida al polo inestable.
Pap=Pap1*Pap2;

optionss=bodeoptions;
%optionss.MagVisible='off';
optionss.PhaseMatching='on';
optionss.PhaseMatchingValue=-170;
optionss.PhaseMatchingFreq=.1;
optionss.Grid='on';

figure();bode(Pmp,P,Pap,optionss,{.01,100000});
set(findall(gcf,'type','line'),'linewidth',2);
legend

figure();bode(Pap1,Pap2,Pap,optionss,{.01,100000});
set(findall(gcf,'type','line'),'linewidth',2);
legend

%%
k = db2mag(30);
C = zpk([-1 -1], [0 -1000 -1000], k);

L = minreal(C * P);

figure();
bode(L, optionss); title('L'); %observo k = 18 dB para wgc = 8 y PM = 60°

figure();

%%
K1=db2mag(41.6)*zpk(inv(Pmp)/s)
L1mp=minreal(Pmp*K1)
L1 = minreal(P*K1)

% K2=zpk(K1*(10+s))
% L2mp=minreal(Pmp*K2)
% eig(1/(1+L2mp))
% L2 = minreal(P*K2)
S1=1/(1+L1);
T1=1-S1;
eig(S1)

%figure(1);bode(Pap,Pap1,Pap2);grid on;
optionss.PhaseMatchingValue=-180;
optionss.PhaseMatchingFreq=20;
figure();bode(L1mp,L1,optionss,{.01,100000});
set(findall(gcf,'type','line'),'linewidth',2);
legend

figure();rlocus(L1);
set(findall(gcf,'type','line'),'linewidth',2);
legend

% figure(3);
% subplot(2,1,1);
% step(T1,1);grid on
% subplot(2,1,2);
% step(K1*S1,1);grid on

% figure(6);bode(L2mp,L2);grid on;
% figure(7);rlocus(L2mp);
% figure(8);rlocus(L2);
% rlocfind(L2);