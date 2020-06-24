classdef NewSensors < handle
    properties
        % inicializacion variables de salida
        Ts % periodo del sistema
        Tmax
        State
        Time
        InitState
        k
        mu
        sigma_alfa
        sigma_beta
        sigma_flecha
        alfa
        beta 
        flecha
        J
        Ta_anterior
        Tb_anterior
        Ff_anterior
    end
    methods
        function obj = NewSensors(dt,tmax,x0)
            obj.Ts = dt;
            obj.Tmax = tmax;
            obj.State = zeros(fix(tmax/dt)+1,6);
            obj.Time = zeros(fix(tmax/dt)+1,1);
            obj.InitState = x0;
            obj.k = 1;
            obj.mu = 0;
            obj.sigma_alfa = 0.1*pi/180;
            obj.sigma_beta = 0.1*pi/180;
            obj.sigma_flecha = 0.02;
            obj.J = 0;
            obj.Ta_anterior = 0;
            obj.Tb_anterior = 0;
            obj.Ff_anterior = 0;
        end
        function obj = update(obj,t1,Ta,Tb,Ff)
            % integrador numerico
            options=odeset('RelTol',1e-4,'AbsTol',1e-6);
            [t,x]=ode23(@(t,x) grua(t,x,Ta,Tb,Ff),[t1 t1+obj.Ts],obj.InitState,options);
            
            % toma ultimo valor del vector
            obj.State(obj.k,:)=x(size(x,2),:);
            
            % toma ultimo valor tiempo simulado
            obj.Time(obj.k,:)=t(max(size(x)));
            
            % usa valor entre 0 y 2pi
            if obj.State(obj.k,1)<0
                obj.State(obj.k,1)=obj.State(obj.k,1)+2*pi;
            end
            if obj.State(obj.k,1)>pi
                obj.State(obj.k,1)=obj.State(obj.k,1)-2*pi;
            end
            
            % usa valor entre 0 y 2pi
            if obj.State(obj.k,2)<0
                obj.State(obj.k,2)=obj.State(obj.k,2)+2*pi;
            end
            if obj.State(obj.k,2)>2*pi
                obj.State(obj.k,2)=obj.State(obj.k,2)-2*pi;
            end
            
            
            % guarda valor de variables para inicio periodo siguiente
            obj.InitState=obj.State(obj.k,:);
            
            %Se agrega ruido a los sensores
            obj.alfa = obj.InitState(1)+ normrnd(obj.mu,obj.sigma_alfa);
            obj.beta = obj.InitState(2)+ normrnd(obj.mu,obj.sigma_beta);
            obj.flecha = obj.InitState(3)+ normrnd(obj.mu,obj.sigma_flecha);
            
            % incrementa periodo
            if obj.k < obj.Tmax/obj.Ts + 1
                obj.k = obj.k + 1;
            else
                obj.k = obj.Tmax/obj.Ts + 1;
            end
        end
        function obj = read(obj)
            obj = [obj.alfa obj.beta obj.flecha];
            
        end
        function obj = cost(obj)
            obj = [obj.J];
        end
            
    end
end