function Game_of_Life()
    close all; clear all; clc;
    N = 100; % to define the world size
    A = zeros(N,N); % to define the world
    A(rand(N,N)<0.5) = 1; % initializing
    A([1,end],:)=0; A(:,[1,end])=0;
    figure(1); set(gcf,'position',[0,0,800,800]);
    imshow(A,'InitialMagnification','fit');
    title(sprintf('GAME OF LIFE: step %06i',0));
    
    for step = 1:500
        B = A;
        for ii = 2:N-1
        for jj = 2:N-1
            NoLN = B(ii-1,jj-1)+B(ii-1,jj)+B(ii-1,jj+1)...
                 + B(ii,jj-1)+B(ii,jj+1)...
                 + B(ii+1,jj-1)+B(ii+1,jj)+B(ii+1,jj+1);
            switch NoLN
                case 2
                    {};
                case 3
                    A(ii,jj) = 1;
                otherwise
                    A(ii,jj) = 0;
            end
        end
        end
        imshow(A,'InitialMagnification','fit');
        title(sprintf('GAME OF LIFE: step %06i',step));
        drawnow();
    end
end