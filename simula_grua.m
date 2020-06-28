close all
clear all
% SIMULACION DE GRUA EN LAZO ABIERTO CON ENTRADA SOLO EN ELEVACION
x0 = [60*pi/180 30*pi/180 5 0 0 0];

%Tiempo de muestreo por defecto
Ts = 1;

%Tiempo de simulación
Tmax = 1000;

%Torques y fuerza iniciales
Ta = 9.82*cos(x0(1)) * (1000*5 + 600*(10+6/2)+500*(10+6));
    
Tb = 0;
Ff = 0.727272* 9.82*sin(x0(1)) * (  600+500);

%Primero se crean los sensores
sensores = NewSensors(Ts,Tmax,x0);

%Variables para guardar los valores leidos
valores = [];
alpha = [];
beta =[];
flecha = [];

int_err_beta=0;
err_beta=0;
ref_beta=10*pi/180;
Kp_beta=170000;
Kd_beta=1000000;
Ki_beta=10000;
k=1;

int_err_alpha=0;
err_alpha=0;
ref_alpha=70*pi/180;
Kp_alpha=300000;
Kd_alpha=1000000;
Ki_alpha=1000000;


Tamax=0;

int_err_flecha=0;
err_flecha=0;
ref_flecha=2;
Kp_flecha=900;
Kd_flecha=1000;
Ki_flecha=200;

error=[];

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
    
    
    % beta
    err_beta_old=err_beta;
    err_beta=ref_beta-beta_actual;
    
    if k==1, vel_err_beta=0; % velocidad del error (0 para 1a iteracion)
    else vel_err_beta=(err_beta-err_beta_old)/Ts;
    end
  
   
    int_err_beta=int_err_beta+abs(err_beta);
   
    if err_beta<10
        int_err_beta=0;
    end

    Tb=Kp_beta*err_beta+Kd_beta*vel_err_beta+Ki_beta*int_err_beta;
    
    % alpha
    err_alpha_old=err_alpha;
    err_alpha=ref_alpha-alpha_actual;
    
    if k==1, vel_err_alpha=0; % velocidad del error (0 para 1a iteracion)
    else vel_err_alpha=(err_alpha-err_alpha_old)/Ts;
    end
    
   
    int_err_alpha=int_err_alpha+abs(err_alpha);
   
    if err_alpha<10
        int_err_alpha=0;
    end

    Ta=(Kp_alpha*err_alpha+Kd_alpha*vel_err_alpha+Ki_alpha*int_err_alpha)...
        + 9.82*cos(ref_alpha) * (1000*5 + 600*(10+6/2)+500*(10+6));
    
  
%     disp(err_alpha)
    
%     if Ta>Tamax
%         Tmax=Ta;
%     end
%       

%  % flecha
    err_flecha_old=err_flecha;
    err_flecha=ref_flecha-flecha_actual;
    
    if k==1, vel_err_flecha=0; % velocidad del error (0 para 1a iteracion)
    else vel_err_flecha=(err_flecha-err_flecha_old)/Ts;
    end
    
   
    int_err_flecha=int_err_flecha+abs(err_flecha);
   
    if err_flecha<10
        int_err_flecha=0;
    end

    Ff=(Kp_flecha*err_flecha+Kd_flecha*vel_err_flecha+Ki_flecha*int_err_flecha)...
        + 0.727272*9.82*sin(ref_alpha) * (600+500); %factor para compensar roce
    
    
    %Ejemplo para almacenar valores
    alpha = [alpha; alpha_actual];
    beta = [beta; beta_actual];
    flecha = [flecha; flecha_actual];
    error=[error;err_flecha];
    disp(ref_alpha);

     k=k+1;
    
end

%Graficando alpha

figure(1)
subplot(3,1,1)
plot(alpha*180/pi); title('Elevacion [grados]')
subplot(3,1,2)
plot(beta*180/pi); title('Azimut [grados]') 
subplot(3,1,3)
plot(flecha);  title('Desplazamiento flecha [m]')

 figure(2)
 plot(error);



