function [P,nod,ele]=cochlea_model_2d_passive_neely(freq,Us)
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
    
    w = 2*pi*freq;
    Z = k-m*w*w+1i*w*r;
    idx = zeros(5*M*N,1);
    jdx = zeros(5*M*N,1);
    tmp = zeros(5*M*N,1);
    flag = 0;

    FF = zeros(M*N,1);
    % the domain | Pxx+Pyy-jw/c/c*P=0
    for ii = 2:M-1
        for jj = 2:N-1
            pc = grids(ii,jj);
            pn = grids(ii,jj+1);
            ps = grids(ii,jj-1);
            pw = grids(ii-1,jj);
            pe = grids(ii+1,jj);
            idx(flag+1:flag+5) = [pc pc pc pc pc];
            jdx(flag+1:flag+5) = [pn ps pw pe pc];
            % tmp(flag+1:flag+5) = [dyy,dyy,dxx,dxx,-2*dxx-2*dyy-1i*w/c/c]; %compressible
            tmp(flag+1:flag+5) = [dyy,dyy,dxx,dxx,-2*dxx-2*dyy]; %incompressible
            flag = flag+5;
        end
    end
    % upper | Py=0
    for ii = 1:M
        pc = grids(ii,N);
        ps = grids(ii,N-1);
        idx(flag+1:flag+2) = [pc,pc];
        jdx(flag+1:flag+2) = [pc,ps];
        tmp(flag+1:flag+2) = [1,-1]/dy;
        flag = flag + 2;
    end
    % bottom | Py + 2\rho*w*w/Z * P = 0
    for ii = 1:M
        pc = grids(ii,1);
        pn = grids(ii,2);
        idx(flag+1:flag+2) = [pc,pc];
        jdx(flag+1:flag+2) = [pc,pn];
        tmp(flag+1:flag+2) = [-1/dy+2*rho*w*w/Z(ii),1/dy];
        flag = flag + 2;
    end
    % left | Px = 2 \rho w*w Us
    for jj = 2:N-1
        pc = grids(1,jj);
        pe = grids(2,jj);
        idx(flag+1:flag+2) = [pc,pc];
        jdx(flag+1:flag+2) = [pc,pe];
        tmp(flag+1:flag+2) = [-1,1]/dx;
        FF(pc) = 2*rho*w*w*Us;
        flag = flag + 2;
    end
    % right| P = 0
    for jj = 2:N-1
        pc = grids(M,jj);
        idx(flag+1) = [pc];
        jdx(flag+1) = [pc];
        tmp(flag+1) = [1]/dx;
        FF(pc) = 0;
        flag = flag + 1;
    end
    KK = sparse(idx(1:flag),jdx(1:flag),tmp(1:flag),M*N,M*N);
    P = KK\FF;
    [nod,ele] = createGridMesh(M,N,L,H);
    pressure = P(grids(1:M,1));
    displacement = -pressure./Z;
        
    figure(1);
    subplot(2,2,1); hold on; grid on;
    plot(x, 20*log10(abs(pressure)), 'k-', 'linewidth', 2);
    xlabel('distance from the stapes, x (m)');
    ylabel('pressure difference in dB'); 
    set(gca,'xlim',[0,L],'ylim',[70,200]);
    
    subplot(2,2,2); hold on; grid on;
    plot(x, 20*log10(abs(displacement/Us)), 'k-', 'linewidth', 2);
    xlabel('distance from the stapes, x (m)');
    ylabel('BM displacement re stapes in dB');
    set(gca,'xlim',[0,L],'ylim',[-45,20]);
    
    subplot(2,2,3); hold on; grid on;
    plot(x, unwrap(angle(pressure))/pi, 'k-', 'linewidth', 2);
    xlabel('distance from the stapes, x (m)');
    ylabel('pressure phase, \pi');
    set(gca,'xlim',[0,L]);
    
    subplot(2,2,4); hold on; grid on;
    plot(x, unwrap(angle(displacement))/pi, 'k-', 'linewidth', 2);
    xlabel('distance from the stapes, x (m)');
    ylabel('disp. phase, \pi');
    set(gca,'xlim',[0,L]);
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