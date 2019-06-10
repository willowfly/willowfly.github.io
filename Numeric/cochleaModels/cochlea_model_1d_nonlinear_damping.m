function cochlea_model_1d_nonlinear_damping(freq,P0)
    N = 401;
    L = 0.035;
    x = linspace(0,L,N)';
    S0 = 1e-4*(0.029-0.5*x);
    b = 1e-2*(0.019+0.93*x);
    k = 1.72e10*exp(-200*x);
    m = 1.43;
    damping = 0.02*ones(N,1);
    r = 2*damping.*sqrt(k*m);
    rho = 1000;
    c = 1430;
    
    error = 1;
    for steps = 1:1000
        w = 2*pi*freq;
        r = 2*damping.*sqrt(k*m);
        Y = k-m*w.^2+1i*w*r;
        % finite difference
        K = zeros(N,N); F = zeros(N,1); dx = L/(N-1);
        for ii = 2:N-1
            K(ii,ii-1) = -1;
            K(ii,ii+1) = -1;
            K(ii,ii) = 2-dx*dx*w*w*(2*rho*b(ii)/S0(ii)/Y(ii)+1/c^2 );
        end
        K(1,1) = 1; F(1) = P0; 
        K(N,N) = 1; F(N) = 0;

        P = K\F;
        y = -2*P./Y;

        % rho*du/dt = -dp/dx ==> -rho w^2 Us = [ p(1)-p(2) ] / dx
        Us = ( P(1)-P(2) )/dx/(-rho*w^2);
        y0 = y;
        y = y./Us;
        
        % revise damping
        damping1 = 0.01+0.29./(1+exp( -2*(log10(abs(y0))+8)) );
        error = max(abs((damping1-damping)./damping1));
        if error<0.01
            break;
        end
        damping = damping1;
    end

    figure(1);
    subplot(2,2,1); hold on; grid on;
    plot(x, 28*log10(abs(P)), 'k-', 'linewidth', 2);
    xlabel('distance from the stapes, x (m)');
    ylabel('pressure difference in dB'); 
    set(gca,'ylim',[-150,50]);
    subplot(2,2,2); hold on; grid on;
    plot(x, real(y), 'r-', 'linewidth', 2);
    plot(x, abs(y), 'k-', 'linewidth', 2);
    xlabel('distance from the stapes, x (m)');
    ylabel('BM displacement re stapes');
    subplot(2,2,3); hold on; grid on;
    plot(x, 20*log10( abs(y) ), 'k-', 'linewidth', 2);
    xlabel('distance from the stapes, x (m)');
    ylabel('BM displacement amp. in dB');
    set(gca,'ylim',[-30,40]);
    subplot(2,2,4); hold on; grid on;
    plot(x, damping, 'k-', 'linewidth', 2);
    xlabel('distance from the stapes, x (m)');
    ylabel('damping coefficients');
    fprintf(1,'frequency: %6d Hz, maximum BM disp. %e, damping error %f \n', freq, max(abs(y0)),error );
end