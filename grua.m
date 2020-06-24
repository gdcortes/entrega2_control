function xprima=grua(t,x,Ta,Tb,Ff)
g = 9.82;  % gravedad
M = 500;   % masa de carga  
Mb = 1000; % masa del brazo
Mf = 600;  % masa flecha
Lb = 10;   % largo brazo
kr= 5000.0; % coefiente roce rotacional 
kl= 2000.0; % coefiente roce lineal
TorqueMax=900000; % torque maximo disponible, motores alfa y beta
FuerzaMax=50000;  % fuerza maxima disponible, motor flecha

% TORQUES Y FUERZA MAXIMO DE MOTORES
if Ta>TorqueMax, Ta=TorqueMax; end;
if Ta<-TorqueMax, Ta=-TorqueMax; end;
if Tb>TorqueMax, Tb=TorqueMax; end;
if Tb<-TorqueMax, Tb=-TorqueMax; end;
if Ff>FuerzaMax, Ff=FuerzaMax; end;
if Ff<-FuerzaMax, Ff=-FuerzaMax; end;

% ECUACIONES DIFERENCIALES SIMPLIFICADAS
aux1=(12*(Ta-(1/2)*g*cos(x(1))*(Lb*(2*M+Mb+2*Mf)+(2*M+Mf)*x(3))-kr*x(4)- ...
    (1/8)*(Lb^2*(4*M+Mb+4*Mf)+4*Lb*(2*M+Mf)*x(3)-(4*M+Mf)*x(3)^2)*sin(2*x(1))*x(5)^2- ...
    (1/6)*(12*Lb*(2*M+Mf)-(24*M+7*Mf)*x(3))*x(4)*x(6)))/(Lb^2*(24*M+7*Mb+24*Mf)+24*Lb*(2*M+Mf)*x(3)+(24*M+7*Mf)*x(3)^2);

aux2=(12*(Tb-kr*x(5)-(1/12)*x(5)*(-3*(Lb^2*(4*M+Mb+4*Mf)+ ...
    4*Lb*(2*M+Mf)*x(3)+(4*M+Mf)*x(3)^2)*sin(2*x(1))*x(4)+(6*Lb*(2*M+Mf)*(3+cos(2*x(1)))+(36*M+11*Mf+ ...
    3*(4*M+Mf)*cos(2*x(1)))*x(3))*x(6))))/(Lb^2*(4*(3*M+Mb+3*Mf)+3*(4*M+Mb+4*Mf)*cos(x(1))^2)+ ...
    6*Lb*(2*M+Mf)*(3+cos(2*x(1)))*x(3)+(4*(3*M +Mf)+3*(4*M+Mf)*cos(x(1))^2)*x(3)^2);

aux3=(1/(3*(4*M+Mf)))*(12*Ff-12*g*M*sin(x(1))-6*g*Mf*sin(x(1))-12*kl*x(6));

xprima(1)=x(4);
xprima(2)=x(5);
xprima(3)=x(6);
xprima(4)=aux1;
xprima(5)=aux2;
xprima(6)=aux3;

xprima=xprima';