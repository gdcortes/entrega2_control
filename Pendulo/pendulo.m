function yprima=pendulo(t,y,F,Kroce)
l=1;    % largo viga
m=1;    % masa pequeña
M=10;   % masa carro
g=9.8;  % gravedad

aux1=(l*sin(y(3))*y(4)^2 + F/m - g*sin(y(3))*cos(y(3)))/((M+m)/m-cos(y(3))^2);
yprima(1)=y(2);
yprima(2)=aux1;
yprima(3)=y(4);
yprima(4)=-(cos(y(3))/l)*aux1+g*sin(y(3))/l-Kroce*(sin(y(3))*y(2)+y(4));

yprima=yprima';
