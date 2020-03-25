function main(para)
M = 256; N = 128;
A = zeros(M,N);
rulenumber = dec2bin(para,8);
A(1,64) = 1;
A(1,:) = rand(1,N)<0.4;

figure(1);
set(gcf,'position',[0,0,500,1000]);
imshow(A,'InitialMagnification','fit');
for ii = 2:1000
    if ii<=M
        Lup = A(ii-1,:);
    else
        Lup = A(M,:);
    end
    Lthis = Lup*0;
    for jj = 1:N
        switch jj
        case 1
            left = Lup(N);
            middle = Lup(jj);
            right = Lup(jj+1);
        case N
            left = Lup(jj-1);
            middle = Lup(jj);
            right = Lup(1);
        otherwise
            left = Lup(jj-1);
            middle = Lup(jj);
            right = Lup(jj+1);
        end
        Lthis(jj) = rules(left,middle,right,rulenumber);
    end
    if ii<=M
        A(ii,:) = Lthis;
    else
        A(1:M-1,:) = A(2:M,:);
        A(M,:) = Lthis;
    end

    imshow(A,'InitialMagnification','fit');
    drawnow();
end
end

% rules function
function ans = rules(left,middle,right,rulenumber)
    tmp = 4*left+2*middle+right;
    ans = str2num(rulenumber(8-tmp));
end