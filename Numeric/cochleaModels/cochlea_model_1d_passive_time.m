function cochlea_model_1d_passive_time(t,p0,plotstyle)
    N = 401; L=0.035;
    x = linspace(0,L,N)';
    S0 = 1e-4*(0.029-0.5*x);
    b = 1e-2*(0.019+0.93*x);
    k = 1.72e10*exp(-200*x);
    m = 1.43;
    damping = 0.05*ones(N,1);
    r = 2*damping.*sqrt(k*m);
    c = 1430;
    rho = 1000;
    
    dx = L/(N-1);
    [M,R,K] = generateMatrix(N,S0,b,k,m,r,rho,c,dx);
    X0 = zeros(2*N,1);
    dX0 = zeros(2*N,1);
    ddX0 = zeros(2*N,1);
    
    figure(1); hold on; grid on;
    line = plot(x,X0(N+1:end),'k-','linewidth',2);
    up = 0*x; dn = 0*x;
    upline = plot(x,up,'r.');
    dnline = plot(x,dn,'r.');
    xlabel('distance from the stapes, x (m)');
    ylabel('BM displacement, (m)');
    
    for kk = 2:length(t)
        % time development
       [X2,dX2,ddX2] = compositeMethod(X0,dX0,ddX0,M,R,K,t(kk-1:kk),p0(kk-1:kk)); 
       X0 = X2; dX0 = dX2; ddX0 = ddX2;
       y  = X0(N+1:end);
       up = up*0.996;
       dn = dn*0.996;
       up = max([up y]')';
       dn = min([dn y]')';
       if plotstyle==1
           if kk<length(t)
               continue;
           end
       end
       set(line,'yData',y);
       set(upline,'yData',up);
       set(dnline,'yData',dn);
       title(sprintf('time: %10.6f',t(kk)));
       axis([0,0.035,-3e-8,3e-8]);
       drawnow(); pause(0.02);
    end
end

% generate stiff matrices
function [M,R,K] = generateMatrix(N,S0,b,k,m,r,rho,c,dx)
    M0  = sparse(N,N);
    Mpp = sparse(2:N-1,2:N-1,1/c^2*ones(N-2,1),N,N);
    Mpu = sparse(2:N-1,2:N-1,-rho*b(2:N-1)./S0(2:N-1),N,N);
    Muu = sparse(1:N,1:N,m*ones(N,1),N,N);
    Mup = M0;
    Ruu = sparse(1:N,1:N,r,N,N);
    Rpp = M0;
    Rpu = M0;
    Rup = M0;
    Kuu = sparse(1:N,1:N,k,N,N);
    Kup = sparse(1:N,1:N,2*ones(N,1),N,N);
    Kpu = M0;
    idx = zeros(3*N,1); jdx = idx; tmp = idx; flag=0;
    for ii = 2:N-1
        idx(flag+1:flag+3) = [ii ii ii];
        jdx(flag+1:flag+3) = [ii-1,ii,ii+1];
        tmp(flag+1:flag+3) = -[1,-2,1]/dx/dx;
        flag = flag + 3;
    end
    Kpp = sparse(idx(1:flag),jdx(1:flag),tmp(1:flag),N,N);
    M = [Mpp,Mpu;Mup,Muu];
    R = [Rpp,Rpu;Rup,Ruu];
    K = [Kpp,Kpu;Kup,Kuu];
end

% time development
function [X2,dX2,ddX2] = compositeMethod(X0,dX0,ddX0,M,R,K,t,p)
    N = size(M,1)/2;
    gamma = 1/sqrt(2);
    dt = t(2)-t(1);
    p0 = p(1); p2 = p(1); p1 = p0+gamma*(p2-p0); 
    % first step
    KK = 4/gamma^2/dt/dt*M+2/gamma/dt*R+K;
    FF = 4/gamma^2/dt/dt*M*X0+4/gamma/dt*M*dX0+M*ddX0+2/gamma/dt*R*X0+R*dX0;
    tmp = max(abs(diag(KK)));
    KK(1,1) = tmp; FF(1) = p1*tmp; 
    KK(N,N) = tmp; FF(N) = 0;
    X1 = KK\FF;
    dX1 = 2/gamma/dt*(X1-X0)-dX0;
    ddX1 = 2/gamma/dt*(dX1-dX0)-ddX0;
    % second step
    c1 = (1-gamma)/gamma/dt;
    c2 = -1/gamma/dt/(1-gamma);
    c3 = (2-gamma)/(1-gamma)/dt;
    KK = c3^2*M+c3*R+K;
    FF = -(c1*c3*M+c1*R)*X0-(c2*c3*M+c2*R)*X1-c1*M*dX0-c2*M*dX1;
    tmp = max(abs(diag(KK)));
    KK(1,1) = tmp; FF(1) = p2*tmp; 
    KK(N,N) = tmp; FF(N) = 0;
    X2 = KK\FF;
    dX2 = c1*X0+c2*X1+c3*X2;
    ddX2 = c1*dX0+c2*dX1+c3*dX2;
end