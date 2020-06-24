close all
clear
% SIMULACION DE GRUA EN LAZO ABIERTO CON ENTRADA SOLO EN ELEVACION
x0 = [0 0 0 0 0 0];

%Tiempo de muestreo por defecto
Ts = 1;

%Tiempo de simulación
Tmax = 1000;

%Torques y fuerza iniciales
Ta = 0;
Tb = 0;
Ff = 0;

%Primero se crean los sensores
sensores = NewSensors(Ts,Tmax,x0);

%Variables para guardar los valores leidos
valores = [];
alpha = [];
beta =[];
flecha = [];

err_beta=0;
ref_beta=50*pi/180;
Kp=500;

%Simulación
for t_actual=0:Ts:Tmax
    
    %Ejemplo de un control en el que se cambia
    %el torque en alfa cuando t = 18[s]
    %if t_actual >= 18
     %   Ta = 0;
    %end
    
    %Se actualizan los sensores y la planta
    %con los valores en los actuadores actuales
    sensores.update(t_actual,Ta,Tb,Ff);
    
    %Para leer los sensores alfa, beta y flecha
    sensores.read(); %Devuelve un arreglo de 1x3 de los valores actuales
    
    %Si se quieren ver por separado
    valores = sensores.read();
    alpha_actual = valores(1);
    beta_actual=valores(2);
    flecha_actual = valores(3);
    
    err_beta_old=err_beta;
    err_beta=ref_beta-beta_actual;
    Tb=Kp*err_beta;
    %Ejemplo para almacenar valores
    alpha = [alpha; alpha_actual];
    beta = [beta; beta_actual];
    flecha = [flecha; flecha_actual];
    
end

%Graficando alpha

figure(1)
subplot(3,1,1)
plot(alpha*180/pi); title('Elevacion [grados]')
subplot(3,1,2)
plot(beta*180/pi); title('Azimut [grados]') 
subplot(3,1,3)
plot(flecha);  title('Desplazamiento flecha [m]')


