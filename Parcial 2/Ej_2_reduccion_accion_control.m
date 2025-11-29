%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ejemplo 2 para reducir accion de control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

%Especificaciones: MF =60º y accion integral. Controlador digital

% Configuración del Bode
my_bode_options = bodeoptions;
my_bode_options.PhaseMatching = 'on';    
my_bode_options.PhaseMatchingFreq = 1;
my_bode_options.PhaseMatchingValue = -180;
my_bode_options.Grid = 'on';
my_bode_options.XLim = {[1 1e4]};

P = zpk([],[-0.0659,-0.4185, -2.266],1);  %Definicion de planta 

%Propongo un controlador con accion integral y bipropio 
k = 1;
C = zpk([-0.0659,-0.4185, -2.266],[0 -1e3 -1e3],k); %Accion integral
figure();
bode(minreal(C*P), my_bode_options);
title('Bode L = C*P con k=1');

%Graficamente veo que puedo proponer estos valores de wgc 
wgc = [100 10];  

for i=1:2
    %Ajusto ganancia del controlador 
    k = [db2mag(160) db2mag(140)];   
    C = zpk([-0.0659,-0.4185, -2.266],[0 -1e3 -1e3],k(i)); %Con ajuste de k
    figure();
    bode(minreal(C*P), my_bode_options);
    title(['Bode L = C*P con "k" ajustado y con wgc=',num2str(wgc(i))]);

    %Determino el Pade del controlador digital
    Phase_dig = [18 31.1] ;  %Graficamente veo cuanto necesito retrasar para tener MF=60°
    Ts = 4*tan(deg2rad(Phase_dig(i)/2))/wgc(i);
    s = tf('s');
    Cd = minreal(series(C,(1 - Ts/4 * s)/(1 + Ts/4 * s)));

    %Incorporo retraso del Pade del controlador al digitalizarlo 
    figure();
    bode(minreal(Cd*P), my_bode_options);
    title(['Bode L = Cd*P con controlador digitalizado y con wgc=',num2str(wgc(i))]);

    %Grafico salida y accion de control
    T = minreal(feedback(Cd*P,1));
    CS = minreal(feedback(Cd,P));
    figure();
    subplot(2,1,1),step(T,0.25);
    title(['Respuesta al escalon de T y con wgc=',num2str(wgc(i))]);
    xlabel('Tiempo [seg]');
    ylabel('Salida controlada');
    subplot(2,1,2),step(CS,0.25);
    [U,T]=step(CS,0.25);
    umax=max(U);
    disp(['Accion de control umax=',num2str(umax),' usando wgc=',num2str(wgc(i))]); 
    title(['Respuesta al escalon de CS y con wgc=',num2str(wgc(i))]);
    xlabel('Tiempo [seg]');
    ylabel('Accion de control');
end
