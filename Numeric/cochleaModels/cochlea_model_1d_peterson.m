function cochlea_model_1d_peterson(frequency)
    N = 401;
    L = 0.035;
    x = linspace(0,L,N)';
    S0 = 1e-4*(0.029-0.5*x);
    b = 1e-2*(0.019+0.93*x);
    k = 1.72e10*exp(-200*x);
    m = 1.43;
    r = 2*0.02*sqrt(k*m);
    rho = 1000;
    c = 1430;
    
    for freq = frequency
        w = 2*pi*freq;
        Y = k-m*w.^2+1i*w*r;
        
        % finite difference
        K = zeros(N,N); F = zeros(N,1); dx = L/(N-1);
        for ii = 2:N-1
            K(ii,ii-1) = -1;
            K(ii,ii+1) = -1;
            K(ii,ii) = 2-dx*dx*w*w*(2*rho*b(ii)/S0(ii)/Y(ii)+1/c^2 );
        end
        K(1,1) = 1; F(1) = 1; 
        K(N,N) = 1; F(N) = 0;
        
        P = K\F;
        y = -2*P./Y;
        
        % rho*du/dt = -dp/dx ==> -rho w^2 Us = [ p(1)-p(2) ] / dx
        Us = ( P(1)-P(2) )/dx/(-rho*w^2);
        y0 = y;
        y = y./Us;
        
        figure(1);
        subplot(1,3,1); hold on; grid on;
        plot(x, real(P), 'r-', 'linewidth', 2);
        plot(x, abs(P), 'k-', 'linewidth', 2);
        xlabel('distance from the stapes, x (m)');
        ylabel('pressure difference'); 
        set(gca,'xlim',[0,L]);
        subplot(1,3,2); hold on; grid on;
        plot(x, real(y), 'r-', 'linewidth', 2);
        plot(x, abs(y), 'k-', 'linewidth', 2);
        xlabel('distance from the stapes, x (m)');
        ylabel('BM displacement re stapes');
        set(gca,'xlim',[0,L]);
        subplot(1,3,3); hold on; grid on;
        plot(x, 20*log10( abs(y) ), 'k-', 'linewidth', 2);
        xlabel('distance from the stapes, x (m)');
        ylabel('BM displacement amp. in dB');
        set(gca,'xlim',[0,L]);
        fprintf(1,'frequency: %6d Hz, maximum BM disp. %e , velo. %e \n',...
            freq, max(abs(y0)), max(abs(1i*w*y0)) );
    end
end