% CAIDA LIBRE DEL PENDULO
clear
F=0; % fuerza externa en cero
Kroce=0.7; % coeficiente roce con el aire
y0=[0.1 0 10*pi/180 0]; % condiciones iniciales
dt=0.01;  % periodo del sistema
k=1;
tmax=19.0;  % tiempo maximo de la simulacion

% inicializacion variables de salida
yt=zeros(fix(tmax/dt)+1,4);
tt=zeros(fix(tmax/dt)+1,1);

for t1=0:dt:tmax
    % integrador numerico
    [t,y]=ode23(@(t,y) pendulo(t,y,F,Kroce),[t1 t1+dt],y0);
    
    % toma ultimo valor del vector
    yt(k,:)=y(max(size(y)),:);
    
    % usa valor entre 0 y 2pi
    if yt(k,3)<0, yt(k,3)=yt(k,3)+2*pi; end;
    if yt(k,3)>2*pi, yt(k,3)=yt(k,3)-2*pi; end;
    
    % toma ultimo valor tiempo simulado
    tt(k,:)=t(max(size(y)));
    
    % guarda valor de variables para inicio periodo siguiente
    y0=yt(k,:);
    
    % incrementa periodo
    k=k+1;
end

% dibuja respuesta de angulo
plot(tt,yt(:,3)*180/pi); xlabel('tiempo, segs'); ylabel('Theta, grados'); pause  

% dibuja respuesta de desplazamiento horizontal 
plot(tt,yt(:,1)); xlabel('tiempo, segs'); ylabel('x(t), metros');