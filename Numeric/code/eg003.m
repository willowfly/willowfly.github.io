close all; clear all; clc;
% basic settings
f1 = 1;
f2 = -0.1;
a  = 0;
b  = 0;
L = 1; N = 21;
nod = linspace(0,L,N)'; ele = [1:N-1; 2:N]';
nnod= size(nod,1); [nele,etyp] = size(ele);
s = zeros(nele,1); f = zeros(nele,1);
for ee = 1:nele
    elee = ele(ee,:); node = nod(elee,:);
    xc = mean(node(:,1));
    if(xc<=0.5) f(ee) = f1; end
    if(xc>0.5) f(ee) = f2; end 
    s(ee) = 1;
end
dbc = [1,a; N,b];
% element 
Kidx = zeros(nele*etyp^2,1);
Kjdx = zeros(nele*etyp^2,1); Ktmp = zeros(nele*etyp^2,1);
Kflag = 0; F = zeros(nnod,1);
for ee = 1:nele
    elee = ele(ee,:); node = nod(elee,:); 
    fe = f(ee); se = s(ee);
    dL = node(2) - node(1);
    Ke = [1 -1;-1 1]/dL;
    Fe = -se*[0.5; 0.5]*dL;
    list = elee';
    Kidx(Kflag+1:Kflag+etyp^2) = [list;list];
    Kjdx(Kflag+1:Kflag+etyp^2) = [list list]';
    Ktmp(Kflag+1:Kflag+etyp^2) = fe*Ke(:); Kflag = Kflag + etyp^2;
    F(list) = F(list) + Fe;
end
Kstiff = sparse(Kidx(1:Kflag),Kjdx(1:Kflag),Ktmp(1:Kflag),nnod,nnod);
largevalue              = 1.0e8;
indexI                  = zeros(size(dbc,1),1);
KBCtmp                  = zeros(size(dbc,1),1);
Kdiag                   = diag(Kstiff);
Kii                     = Kdiag(dbc(:,1));
for ii = 1:size(dbc,1)
    bcdofs              = dbc(ii,1);
    bcvalu              = dbc(ii,2);
    indexI(ii)          = bcdofs;
    KBCtmp(ii)          = -Kii(ii) + Kii(ii) * largevalue;
end
F(dbc(:,1),1) = largevalue*Kii.*dbc(:,2);
KBC = sparse(indexI,indexI,KBCtmp,size(Kstiff,1),size(Kstiff,2) );
Kstiff = Kstiff + KBC;
% solve 
p = Kstiff\F;
% plot
figure(1); hold on; grid on;
set(gcf,'position',[0,0,800,400]); set(gcf,'color',[1 1 1]*(238-1)/256);
x = linspace(0,L,201)'; 
A = -(3*f1+f2+8*(a-b)*f1*f2)/(4*(f1+f2)); B = a;
C = b + (f1-f2+8*(a-b)*f1*f2)/(4*f2*(f1+f2));
p1 = x.^2/2/f1 + A*x/f1 + B;
p2 = x.^2/2/f2 + A*x/f2 + C;
p_exact = (x<=0.5).*p1 + (x>0.5).*p2;
plot(x,p_exact,'k-','linewidth',2);
x = linspace(0,L,N)'; 
plot(x,p,'ro','markersize',6,'markerfacecolor','r');
legend('exact solution','finite element solution');
xlabel('x'); ylabel('p(x)'); set(gca,'fontsize',16);
