function cochlea_model_2d_passive_neely_time(t,Ast,plotstyle)
    M = 257; N = 17;
    L = 0.035; H = 0.001;
    rho = 1000; c = 1430;
    x = linspace(0,L,M)';
    m = 1.5;
    r = 2000;
    k = 1e10*exp(-200*x);
    grids = reshape(1:M*N,M,N);
    dx = L/(M-1); dxx = 1/(dx*dx);
    dy = H/(N-1); dyy = 1/(dy*dy);
    [nod,ele] = createGridMesh(M,N,L,H);
    % m \ddot{\eta} + r\dot{\eta} + k\eta + 2p = 0
    Fp  = zeros(M*N,1);
    Fe  = zeros(M,1);
    Mee = sparse(1:M,1:M,m.*ones(M,1),M,M);
    Mep = sparse(M,M*N);
    Ree = sparse(1:M,1:M,r.*ones(M,1),M,M);
    Rep = sparse(M,M*N);
    Kee = sparse(1:M,1:M,k.*ones(M,1),M,M);
    Kep = sparse(1:M,1:M,2.*ones(M,1),M,M*N);
    Mpp = sparse(M*N,M*N);
    Rpe = sparse(M*N,M);
    Kpe = sparse(M*N,M);
    % \nabla^2 p - 1/c/c*\dot{p} = 0 ==> Kpp and Rpp for inner nodes
    Kppidx = zeros(5*M*N,1); Kppjdx = Kppidx; Kpptmp = Kppidx; Kppflag = 0;
    Rppidx = zeros(5*M*N,1); Rppjdx = Rppidx; Rpptmp = Rppidx; Rppflag = 0;
    for ii = 2:M-1
        for jj = 2:N-1
            pc = grids(ii,jj); pn = grids(ii,jj+1); ps = grids(ii,jj-1);
            pw = grids(ii-1,jj); pe = grids(ii+1,jj);
            Kpplist = Kppflag+1:Kppflag+5;
            Kppidx(Kpplist) = [pc pc pc pc pc];
            Kppjdx(Kpplist) = [pn ps pw pe pc];
            Kpptmp(Kpplist) = [dyy dyy dxx dxx -2*dxx-2*dyy];
            Kppflag = Kppflag + 5;
            Rpplist = Rppflag+1;
            Rppidx(Rpplist) = [pc];
            Rppjdx(Rpplist) = [pc];
            Rpptmp(Rpplist) = -1/c/c;
        end
    end
    % Upper nodes dp/dy = 0 ===> only affects Kpp
    for ii = 1:M
        pc = grids(ii,N); ps = grids(ii,N-1);
        Kpplist = Kppflag+1:Kppflag+2;
        Kppidx(Kpplist) = [pc pc];
        Kppjdx(Kpplist) = [pc ps];
        Kpptmp(Kpplist) = [-1  1]/dy;
        Kppflag = Kppflag + 2;
    end
    % Bottom nodes dp/dy + 2\rho\ddot{\eta} = 0  ===> Kpp and Mpe
    for ii = 1:M
        pc = grids(ii,1); pn = grids(ii,2);
        Kpplist = Kppflag+1:Kppflag+2;
        Kppidx(Kpplist) = [pc pc];
        Kppjdx(Kpplist) = [pc pn];
        Kpptmp(Kpplist) = [-1  1]/dy;
        Kppflag = Kppflag + 2;
    end
    Mpe = sparse(1:M,1:M,2*rho*ones(M,1),M*N,M);
    % Left nodes dp/dx = -2 \rho Ast ==> Kpp and Fp 
    for jj = 2:N-1
        pc = grids(1,jj); pe = grids(2,jj);
        Kpplist = Kppflag+1:Kppflag+2;
        Kppidx(Kpplist) = [pc pc];
        Kppjdx(Kpplist) = [pc pe];
        Kpptmp(Kpplist) = [-1  1]/dx/(-2)/rho;
        Kppflag = Kppflag + 2; 
    end
    % Fp should generate for each time step
    % Right nodes p = 0 ====> Kpp and Fp
    for jj = 2:N-1
        pc = grids(M,jj);
        Kpplist = Kppflag+1;
        Kppidx(Kpplist) = [pc];
        Kppjdx(Kpplist) = [pc];
        Kpptmp(Kpplist) = 1/dx/dy;
        Kppflag = Kppflag + 1;
        Fp(pc) = 0;
    end
    Kpp = sparse(Kppidx(1:Kppflag),Kppjdx(1:Kppflag),Kpptmp(1:Kppflag),M*N,M*N);
    Rpp = sparse(Rppidx(1:Rppflag),Rppjdx(1:Rppflag),Rpptmp(1:Rppflag),M*N,M*N);
    MMMM = [Mpp Mpe; Mep Mee];
    RRRR = [Rpp Rpe; Rep Ree];
    KKKK = [Kpp Kpe; Kep Kee];
    FFFF = [Fp; Fe];
    X0 = zeros(M*N+M,1);
    dX0 = zeros(M*N+M,1);
    ddX0 = zeros(M*N+M,1);
    
    figure(1); hold on; grid on;
    line = plot(x,X0(end-M+1:end),'k-','linewidth',2);
    up = 0*x; dn = 0*x;
    upline = plot(x,up,'r.');
    dnline = plot(x,dn,'r.');
    xlabel('distance from the stapes, x (m)');
    ylabel('BM displacement, (m)');
    
    for kk = 2:length(t)
        % time development
       [X2,dX2,ddX2] = compositeMethod(X0,dX0,ddX0,MMMM,RRRR,KKKK,FFFF,t(kk-1:kk),Ast(kk-1:kk),grids); 
       X0 = X2; dX0 = dX2; ddX0 = ddX2;
       y  = X0(end-M+1:end);
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
       axis([0,0.035,-10,10]);
       drawnow(); pause(0.02);
    end
end

function [nod,ele] = createGridMesh(M,N,L,H)
    dx = L/(M-1);
    dy = H/(N-1);
    nod = zeros(M*N,2);
    kk = 1;
    for jj = 1:N
        for ii = 1:M
            nod(kk,:) = [dx*(ii-1) dy*(jj-1)];
            kk = kk + 1;
        end
    end
    ele = zeros((M-1)*(N-1),4);
    kk = 1;
    for jj = 1:N-1
        for ii = 1:M-1
            n1 = M*(jj-1)+ii;
            n2 = n1+1;
            n3 = n2+M;
            n4 = n3-1;
            ele(kk,:) = [n1,n2,n3,n4];
            kk = kk + 1;
        end
    end
end

% time development
function [X2,dX2,ddX2] = compositeMethod(X0,dX0,ddX0,M,R,K,F,t,p,grids)
    [m,n] = size(grids);
    gamma = 1/sqrt(2);
    dt = t(2)-t(1);
    p0 = p(1); p2 = p(1); p1 = p0+gamma*(p2-p0); 
    % first step
    points = grids(1,2:n-1);
    Ft = F; Ft(points) = p1;
    KK = 4/gamma^2/dt/dt*M+2/gamma/dt*R+K;
    FF = Ft+4/gamma^2/dt/dt*M*X0+4/gamma/dt*M*dX0+M*ddX0+2/gamma/dt*R*X0+R*dX0;
    X1 = KK\FF;
    dX1 = 2/gamma/dt*(X1-X0)-dX0;
    ddX1 = 2/gamma/dt*(dX1-dX0)-ddX0;
    % second step
    c1 = (1-gamma)/gamma/dt;
    c2 = -1/gamma/dt/(1-gamma);
    c3 = (2-gamma)/(1-gamma)/dt;
    KK = c3^2*M+c3*R+K;
    Ft = F; Ft(points) = p2;
    FF = Ft-(c1*c3*M+c1*R)*X0-(c2*c3*M+c2*R)*X1-c1*M*dX0-c2*M*dX1;
    X2 = KK\FF;
    dX2 = c1*X0+c2*X1+c3*X2;
    ddX2 = c1*dX0+c2*dX1+c3*dX2;
end