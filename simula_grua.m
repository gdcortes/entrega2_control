close all
clear all
% SIMULACION DE GRUA EN LAZO ABIERTO CON ENTRADA SOLO EN ELEVACION
x0 = [0*pi/180 0*pi/180 0 0 0 0];

%Tiempo de muestreo por defecto
Ts = 1;

%Tiempo de simulaci�n
Tmax = 300;



%Primero se crean los sensores
sensores = NewSensors(Ts,Tmax,x0);

%Variables para guardar los valores leidos
valores = [];
alpha = [];
beta =[];
flecha = [];

int_err_beta=0;
err_beta=0;
ref_beta=0*pi/180;
Kp_beta=800000;
Kd_beta=5500000;
Ki_beta=30000;
k=1;

int_err_alpha=0;
err_alpha=0;
ref_alpha=0*pi/180;
Kp_alpha=3000000;
Kd_alpha=15000000;
Ki_alpha=20000;

%%%%
alpha_old=0;
alpha_actual=0;
%%%%%

int_err_flecha=0;
err_flecha=0;
ref_flecha=1;
Kp_flecha=5000;
Kd_flecha=20000;
Ki_flecha=100;



%Torques y fuerza iniciales
Ta = 9.82*cos(x0(1)) * (1000*5 + 600*(10+ref_flecha/2)+500*(10+ref_flecha));
%Ta=0;  
Tb = 0;
Ff = 0.727272* 9.82*sin(x0(1)) * (  600+500);


error=[];

J=0;
J_alfa=0;
J_beta=0;
J_flecha=0;

%Simulaci�n
for t_actual=0:Ts:Tmax
    
%     if t_actual == 0
%         ref_alpha=0;
%         ref_beta=0;
%         ref_flecha=1;
    
    if t_actual >= 100 && t_actual <200
            ref_alpha =75*pi/180;
            ref_beta=185*pi/180;
            ref_flecha=5;
    elseif t_actual >= 200
        ref_alpha=0;
        ref_beta=0;
        ref_flecha=1;
    end
        
%      if ref_beta > pi
%         ref_beta= ref_beta-2*pi;
%     elseif ref_beta < -pi
%         ref_beta=ref_beta+2*pi;
%     end
        
    %%%  
    alpha_old=alpha_actual;
    %%%%%
        
    

    
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
    
    %%%%%%
    if alpha_actual>alpha_old
        Kp_alpha=3000000;
    elseif alpha_actual<alpha_old
        Kp_alpha=2000000;
    end
    
    %%%%%%
    
    
    if beta_actual > pi
        beta_actual= beta_actual-2*pi;
    elseif beta_actual < -pi
        beta_actual=beta_actual+2*pi;
    end
    
    % beta
    err_beta_old=err_beta;
    err_beta=ref_beta-beta_actual;
    
     if err_beta > pi
        err_beta= err_beta-2*pi;
    elseif beta_actual < -pi
        err_beta=err_beta+2*pi;
    end
    
    if k==1, vel_err_beta=0; % velocidad del error (0 para 1a iteracion)
    else vel_err_beta=(err_beta-err_beta_old)/Ts;
    end
  
   
    int_err_beta=int_err_beta+abs(err_beta);
   
    if err_beta<0.01
        int_err_beta=0;
    end
    Tb_old=Tb;
   Tb=Kp_beta*err_beta+Kd_beta*vel_err_beta+Ki_beta*int_err_beta;
    
    % alpha
    err_alpha_old=err_alpha;
    err_alpha=ref_alpha-alpha_actual;
    
    if k==1, vel_err_alpha=0; % velocidad del error (0 para 1a iteracion)
    else vel_err_alpha=(err_alpha-err_alpha_old)/Ts;
    end
    
    
   
    int_err_alpha=int_err_alpha+abs(err_alpha);
    
    if err_alpha<0.01
        int_err_alpha=0;
    end
    Ta_old=Ta;
    Ta=(Kp_alpha*err_alpha+Kd_alpha*vel_err_alpha+Ki_alpha*int_err_alpha)...
       + 9.82*cos(ref_alpha) * (1000*5 + 600*(10+ref_flecha/2)+500*(10+ref_flecha));
    
  


%  % flecha
    err_flecha_old=err_flecha;
    err_flecha=ref_flecha-flecha_actual;
    
    if k==1, vel_err_flecha=0; % velocidad del error (0 para 1a iteracion)
    else vel_err_flecha=(err_flecha-err_flecha_old)/Ts;
    end
    
   
    int_err_flecha=int_err_flecha+abs(err_flecha);
   
    if err_flecha<0.01
        int_err_flecha=0;
    end
    Ff_old=Ff;
    Ff=(Kp_flecha*err_flecha+Kd_flecha*vel_err_flecha+Ki_flecha*int_err_flecha)...
        + 0.727272*9.82*sin(ref_alpha) * (600+500); %factor para compensar roce
    
    
    %Ejemplo para almacenar valores
    alpha = [alpha; alpha_actual];
    beta = [beta; beta_actual];
    flecha = [flecha; flecha_actual];
    error=[error;err_flecha];
    
     
    if t_actual>=100
        J=J+ (err_alpha^2) + (err_beta^2) + (0.02*err_flecha^2) + (0.2*10^(-13)*(Ta-Ta_old)^2) + (0.2*10^(-13)*(Tb-Tb_old)^2) + (0.2*10^(-8)*(Ff-Ff_old)^2); 
        J_alfa= J_alfa + (err_alpha^2) + (0.2*10^(-13)*(Ta-Ta_old)^2);
        J_beta= J_beta +(err_beta^2)+ (0.2*10^(-13)*(Tb-Tb_old)^2);
        J_flecha= J_flecha + (0.02*err_flecha^2) + (0.2*10^(-8)*(Ff-Ff_old)^2);
        if alpha_actual<-10*pi/180
            J=J+10000000;
        elseif alpha_actual>85*pi/180
            J=J+10000000;
        elseif flecha_actual<0
            J=J+10000000;
        elseif flecha_actual>6
            J=J+10000000;
        end
    end
    
     k=k+1;
    
end

%Graficando alpha

disp(J_alfa);
disp(J_beta);
disp(J_flecha);
disp(J);

figure(1)
subplot(3,1,1)
plot(alpha*180/pi); title('Elevacion [grados]')
subplot(3,1,2)
plot(beta*180/pi); title('Azimut [grados]') 
subplot(3,1,3)
plot(flecha);  title('Desplazamiento flecha [m]')

%   figure(2)
%    plot(error);



