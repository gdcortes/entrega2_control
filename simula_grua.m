close all
clear
% SIMULACION DE GRUA EN LAZO ABIERTO CON ENTRADA SOLO EN ELEVACION
x0 = [5*pi/180 0 6 0 0 0];

%Tiempo de muestreo por defecto
Ts = 1;

%Tiempo de simulación
Tmax = 20;

%Torques y fuerza iniciales
Ta = 201000;
Tb = 0;
Ff = 0;

%Primero se crean los sensores
sensores = NewSensors(Ts,Tmax,x0);

%Variables para guardar los valores leidos
valores = [];
alpha = [];
flecha = [];

%Simulación
for t_actual=0:Ts:Tmax
    
    %Ejemplo de un control en el que se cambia
    %el torque en alfa cuando t = 18[s]
    if t_actual >= 18
        Ta = 0;
    end
    
    %Se actualizan los sensores y la planta
    %con los valores en los actuadores actuales
    sensores.update(t_actual,Ta,Tb,Ff);
    
    %Para leer los sensores alfa, beta y flecha
    sensores.read(); %Devuelve un arreglo de 1x3 de los valores actuales
    
    %Si se quieren ver por separado
    valores = sensores.read();
    alpha_actual = valores(1);
    flecha_actual = valores(3);
    
    %Ejemplo para almacenar valores
    alpha = [alpha; alpha_actual];
    flecha = [flecha; flecha_actual];
end

%Graficando alpha
plot(alpha*180/pi); title('Elevacion [grados]')
figure; plot(flecha);  title('Desplazamiento flecha [m]')