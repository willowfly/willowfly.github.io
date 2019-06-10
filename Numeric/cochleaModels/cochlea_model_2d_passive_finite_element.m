function [nod,ele,P,Pup,Pdn,U] = cochlea_model_2d_passive_finite_element(freq)
load('mesh.mat');
omega = 2*pi*freq;
c = 1430; rho=1000;
Ustapes = 1;

bc1 = lines.nodid{8}';
bc1 = [bc1 0*bc1];
bc2 = lines.nodid{9}';
bc2tmp = zeros(length(bc2)-1,3);
for ii = 1:length(bc2)-1
    bc2tmp(ii,1) = bc2(ii);
    bc2tmp(ii,2) = bc2(ii+1);
    bc2tmp(ii,3) = -rho*omega^2*Ustapes;
end
bc2 = bc2tmp;

% coupled bc
doline = lines.nodid{2}'; doline = doline(end:-1:1);
upline = lines.nodid{3}';
bc3tmp_1 = zeros(length(upline)-1,6);
for ii = 1:size(bc3tmp_1,1)
    bc3tmp_1(ii,1) = upline(ii);   % n1sv
    bc3tmp_1(ii,2) = upline(ii+1); % n2sv
    bc3tmp_1(ii,3) = doline(ii);   % n1st
    bc3tmp_1(ii,4) = doline(ii+1); % n2st
    x = nod(upline(ii),1);
    stiffness = 2e10*exp(-270*x);
    mass      = 1.5;
    damping   = 2*0.02*sqrt(stiffness*mass);
    Z1        = stiffness-mass*omega^2+1i*omega*damping;
    x = nod(upline(ii+1),1);
    stiffness = 2e10*exp(-270*x);
    mass      = 1.5;
    damping   = 2*0.02*sqrt(stiffness*mass);
    Z2        = stiffness-mass*omega^2+1i*omega*damping;
    bc3tmp_1(ii,5) = Z1;
    bc3tmp_1(ii,6) = Z2;
end
bc3 = bc3tmp_1;
Z = zeros(length(upline),1);
for ii = 1:length(upline)
    x = nod(upline(ii),1);
    stiffness = 2e10*exp(-270*x);
    mass      = 1.5;
    damping   = 2*0.02*sqrt(stiffness*mass);
    Z(ii)     = stiffness-mass*omega^2+1i*omega*damping;
end

% the main program
[nnod,ndim] = size(nod);
[nele,etyp] = size(ele);
space = nele*etyp^2;
fprintf(1,'number of unknowns:              %10d\n',nnod);
fprintf(1,'elements in the stiffness matrix:%10d\n',space);
space = floor(space*2);

% gauss integral set up
gauss2 = [ -0.577350269189626 0.577350269189626];
weight2= [ 1.0000000000000000 1.000000000000000];
for ii = 1:2
for jj = 1:2
    xi = gauss2(ii);
    et = gauss2(jj);
    W_all(:,ii,jj)   =[ 0.25*(xi-1)*(et-1);
                       -0.25*(xi+1)*(et-1);
                        0.25*(xi+1)*(et+1);
                       -0.25*(xi-1)*(et+1) ];
    Wxi_all(:,ii,jj) =[ 0.25*(et-1);
                       -0.25*(et-1);
                        0.25*(et+1);
                       -0.25*(et+1) ];
    Wet_all(:,ii,jj) =[ 0.25*(xi-1);
                       -0.25*(xi+1);
                        0.25*(xi+1);
                       -0.25*(xi-1) ];
    Weight_all(ii,jj)= weight2(ii)*weight2(jj);  
end
end
% assemble
coe = 1i*omega/c^2;
Kidx  = zeros(space,1);
Kjdx  = zeros(space,1);
Ktmp  = zeros(space,1); Kflag = 0;
Ftmp  = zeros(nnod,1);
for ee = 1:nele
    elee = ele(ee,:);
    node = nod(elee,:);
    Ke = zeros(etyp,etyp); De = Ke; Me = Ke;
    Fe = zeros(etyp,1);
    for ii = 1:2
        for jj = 1:2
            W(:,1)=W_all(:,ii,jj);
            Wxi(:,1)=Wxi_all(:,ii,jj);
            Wet(:,1)=Wet_all(:,ii,jj);
            xy_xiet = node'*[Wxi,Wet];
            jacobi = det(xy_xiet);
            xiet_xy = inv(xy_xiet);
            A = [Wxi Wet]*xiet_xy;
            Wx = A(:,1);Wy = A(:,2);
            De = De + jacobi*Weight_all(ii,jj)*(Wx*Wx'+Wy*Wy');
            Me = Me + jacobi*Weight_all(ii,jj)*(W*W');
            Fe = Fe + 0; % no body force
            Ke = Ke + De + coe*Me;
        end
    end
    list    = elee';
    Kidx(Kflag+1:Kflag+etyp^2) = [list;list;list;list];
    Kjdx(Kflag+1:Kflag+etyp^2) = [list list list list]';
    Ktmp(Kflag+1:Kflag+etyp^2) = Ke(:); Kflag = Kflag + etyp^2;
    Ftmp(list) = Ftmp(list) + Fe(:);
end
% 2rd class boundry conditions
for ii = 1:size(bc2,1)
    n1 = bc2(ii,1); n2 = bc2(ii,2);
    h  = bc2(ii,3);
    xy1 = nod(n1,:); xy2 = nod(n2,:); L = norm(xy2-xy1);
    Fe = h*[0.5;0.5]*L;
    list = [n1;n2];
    Ftmp(list) = Ftmp(list)+Fe(:);
end
% 3rd class boundry conditions / special for bm
for ii = 1:size(bc3,1)
    n1sv = bc3(ii,1); n2sv = bc3(ii,2);
    n1st = bc3(ii,3); n2st = bc3(ii,4);
    Z1 = bc3(ii,5); Z2 = bc3(ii,6);
    % for the SV part
    xy1 = nod(n1sv,:); xy2 = nod(n2sv,:); L = norm(xy1-xy2);
    Ke = [2,1;1,2]/6*L*rho*omega^2*[1/Z1,-1/Z1,0,0; 0,0, 1/Z2,-1/Z2];
    Kidx(Kflag+1:Kflag+8) = [n1sv n2sv n1sv n2sv n1sv n2sv n1sv n2sv];
    Kjdx(Kflag+1:Kflag+8) = [n1st n1st n1sv n1sv n2st n2st n2sv n2sv];
    Ktmp(Kflag+1:Kflag+8) = Ke(:); Kflag = Kflag + 8;
    % for the ST part
    xy1 = nod(n1st,:); xy2 = nod(n2st,:); L = norm(xy1-xy2);
    Ke = -[2,1;1,2]/6*L*rho*omega^2*[1/Z1,-1/Z1,0,0; 0,0, 1/Z2,-1/Z2];
    Kidx(Kflag+1:Kflag+8) = [n1st n2st n1st n2st n1st n2st n1st n2st];
    Kjdx(Kflag+1:Kflag+8) = [n1st n1st n1sv n1sv n2st n2st n2sv n2sv];
    Ktmp(Kflag+1:Kflag+8) = Ke(:); Kflag = Kflag + 8;
end
Kstiff = sparse( Kidx(1:Kflag), Kjdx(1:Kflag), Ktmp(1:Kflag), nnod,nnod);
F      = Ftmp;

% 1rd class boundary conditions
dbc = bc1;
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

% solver
P = full(Kstiff\F);
Pup = P(upline);
Pdn = P(doline);
U   = (Pdn-Pup)./Z;
end