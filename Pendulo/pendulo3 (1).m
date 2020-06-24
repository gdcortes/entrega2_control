% CONTROL DEL PENDULO INVERTIDO EN ANGULO Y POSICION
clear
F=0;    % fuerza sobre bloqie M para equilibrar pendulo
Kroce=0.7; % coeficiente roce con el aire
y0=[0.1 0 10*pi/180 0]; % condiciones iniciales
dt=0.01;  % periodo de simulacion
k=1;

tmax=100.0;    % tiempo maximo de simulacion
yt=zeros(fix(tmax/dt)+1,4);   % inicializacion de variables
tt=zeros(fix(tmax/dt)+1,1);
err=0;
errX=0;
ref=0.0*pi/180;  % referencia angulo pendulo
Xref=1.0;  % referencia posicion horizontal

% parametros de controlador de angulo pendulo
Kp=150;
Kd=20;
% parametros de controlador de posicion masa M
KpX=0.002;
KdX=0.005;

for t1=0:dt:tmax
    % integracion numerica
    [t,y]=ode23(@(t,y) pendulo(t,y,F,Kroce),[t1 t1+dt],y0);
    
    yt(k,:)=y(max(size(y)),:);  % toma ultimo valor del vector  
    if yt(k,3)>pi, yt(k,3)=yt(k,3)-2*pi; end; % usa valor entre [-pi, pi]
    
    tt(k,:)=t(max(size(y))); % toma ultimo valor tiempo simulado
    
    y0=yt(k,:); % guarda valor variables para inicio sgte. periodo
    
    err_old=err;  % guarda error anterior para calculo velocidad
    err=(ref-yt(k,3));  % error nuevo
    
    if k==1, vel_error=0; % velocidad del error (0 para 1a iteracion)
    else vel_error=(err-err_old)/dt; end
    
    F=-(Kp*err+Kd*vel_error); % Controlador 
    
    errX_old=errX;  
    errX=Xref-yt(k,1);  % error en posicion horizontal
    
    % velocidad del error (0 para primera iteracion)
    if k==1, vel_errorX=0;
    else vel_errorX=(errX-errX_old)/dt; end

    % controlador cascada de posicion horizontal
    ref=KpX*errX+KdX*vel_errorX;
    
    % incrementa periodo
    k=k+1;
end

plot(tt,yt(:,3)*180/pi); title('Angulo Theta');

figure; plot(tt,yt(:,1));  title('Desplazamiento del carro');