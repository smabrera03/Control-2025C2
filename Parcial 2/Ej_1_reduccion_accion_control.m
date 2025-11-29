%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ejemplo 1 para reducir accion de control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;
set(0,'DefaultFigureWindowStyle','docked')

%Especificaciones: MF =60º y accion integral. Controlador digital

% Configuración del Bode
my_bode_options = bodeoptions;
my_bode_options.PhaseMatching = 'on';    
my_bode_options.PhaseMatchingFreq = 1;
my_bode_options.PhaseMatchingValue = -180;
my_bode_options.Grid = 'on';
my_bode_options.XLim = {[1 1e4]};

%Definicion de la planta
p = [1 1e3];   %Posibles valores de ganancia de la planta 


for i=1:2
    P(i) = zpk([],[-p(i) 5 -10],p(i));  %Definicion de planta 

    % Separo en parte de fase minima y parte pasatodo
    Pap = zpk(-5,5,1);
    Pmp = zpk([],[-p(i) -10 -5],p(i));

    %Propongo un controlador con accion integral y bipropio 
    k = 1;
    C = zpk([-p(i) -5 -10],[0 -1e3 -1e3],k); %Accion integral
    figure();
    bode(minreal(C*Pmp), my_bode_options);
    title(['Bode Lmp = C*Pmp con k=1 y con p=',num2str(p(i))]);

    %Graficamente veo que puedo proponer wgc = 100 y cumplo con
    %las limitaciones fundamentales considerando wgc > p/tan(deg2rad(Phase_Pap/2)) 
    %considerando un retraso de fase del Pap < 30º
    wgc = 100;  %graficamente veo que se genera un retraso del -5.7 rad/seg 

    %Ajusto ganancia del controlador 
    k = [db2mag(160),db2mag(100)];   %Este valor cambiara segun el caso a analizar 
    C = zpk([-p(i) -5 -10],[0 -1e3 -1e3],k(i)); %Con ajuste de k
    figure();
    bode(minreal(C*Pmp*Pap), my_bode_options);
    title(['Bode L = C*P con "k" ajustado para caso p=',num2str(p(i))]);

    %Determino el Pade del controlador digital
    Phase_dig = [6 12.9];  %Graficamente veo cuanto necesito retrasar para tener MF=60°
    Ts = 4*tan(deg2rad(Phase_dig(i)/2))/wgc;
    s = tf('s');
    Cd = minreal(series(C,(1 - Ts/4 * s)/(1 + Ts/4 * s)));
    C(i) = Cd;
    %Incorporo retraso del Pade del controlador al digitalizarlo 
    figure();
    bode(minreal(Cd*Pmp*Pap), my_bode_options);
    L(i) = minreal(Cd*Pmp*Pap);
    
    title(['Bode L = Cd*P con controlador digitalizado para caso p=',num2str(p(i))]);

    %Grafico salida y accion de control
    T = minreal(feedback(Cd*Pmp*Pap,1));
    CS(i) = minreal(feedback(Cd,Pmp*Pap));
    figure();
    subplot(2,1,1),step(T,0.25);
    title(['Respuesta al escalon de T y con p=',num2str(p(i))]);
    xlabel('Tiempo [seg]');
    ylabel('Salida controlada');
    subplot(2,1,2),step(CS(i),0.25);
    [U,T]=step(CS(i),0.25);
    umax=max(U);
    disp(['Accion de control umax=',num2str(umax),' usando p=',num2str(p(i))]); 
    title(['Respuesta al escalon de CS y con p=',num2str(p(i))]);
    xlabel('Tiempo [seg]');
    ylabel('Accion de control');
    
end