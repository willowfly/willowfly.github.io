function generateBM(folder,line1,line2,line3,line4)

start = 1000000;
folder = textread('__dic.log','%s'); folder = folder{1};
nod = load([folder,'/model_node_spiral.cnn']); nod_list = nod(:,1);
line_inn = load([folder,'/',line1]);
line_out = load([folder,'/',line2]);
line_bas = load([folder,'/',line3]);
line_tip = load([folder,'/',line4]);

start = size(nod,1);

Ta = 0.0075; Tb = 0.0025;
Eya = 100; Eyb = 2.5; 
material = 'orth'; %iso
damping = 'stru';
structuraldamping = 0.15;
betadamping = 5e-6;
alphadamping = 200;

%               line-out  ---->
% ***********************************************************************           
% * ^                                                                   *           
% * | line-base                                                         *  line-tip 
% * |                                                                   *           
% *                                                                     *           
% ***********************************************************************           
%               line-inner  ---->
%

if isempty(line_tip)~=1; M = length(line_tip); end
if isempty(line_bas)~=1; M = length(line_bas); end
N = length(line_out); 
L = zeros(N,1);
%% calculate the length of the BM
for jj = 1:N
    n1 = line_inn(jj); n2 = line_out(jj);
    n1_index = find(nod_list==n1);
    n2_index = find(nod_list==n2);
    loc1 = nod(n1_index,2:end);
    loc2 = nod(n2_index,2:end);
    locc = (loc1+loc2)/2;
    if jj == 1;
        L(jj) = 0;
        locc0 = locc;
    else
        dL = norm(locc-locc0);
        L(jj)  = L(jj-1) + dL;
        locc0 = locc;
    end
end
fprintf('The length of the BM mid-line is about %f mm\n', L(end));

%% Generate the BM nodes
bmnodlist = zeros(N,M);
bmnod     = zeros(3,N,M);
fid_nod = fopen([folder,'/input-inst1-node-bm.inp'],'w'); 
fid_thk = fopen([folder,'/input-distribution-thick.inp'],'w');
fid_ele = fopen([folder,'/input-inst1-elem-bm.inp'],'w');
fid_set = fopen([folder,'/input-inst1-bm-set.inp'],'w');
fid_mat = fopen([folder,'/input-inst1-bm-mat.inp'],'w');
fid_sec = fopen([folder,'/input-inst1-bm-sec.inp'],'w');
fid_mid = fopen([folder,'/input-inst1-bm-mid.inp'],'w');

kk = start;
%% node & node thickness
if isempty(line_bas)~=1
    iistart = 2;
    for ii = 1:1
        for jj = 1:M
            n1 = line_bas(jj);
            n1_index = find(nod_list==n1);
            loc1 = nod(n1_index,2:end);
            bmnodlist(ii,jj) = n1;
            bmnod(:,ii,jj) = loc1;
        end
    end
else
    iistart = 1;
end
if isempty(line_tip)~=1
    iiend = N-1;
else
    iiend = N;
end

for ii = iistart:iiend
    n1 = line_inn(ii); n2 = line_out(ii);
    n1_index = find(nod_list==n1);
    n2_index = find(nod_list==n2);
    loc1 = nod(n1_index,2:end);
    loc2 = nod(n2_index,2:end); 
    bmnodlist(ii,1) = n1; bmnodlist(ii,M) = n2;
    bmnod(:,ii,1) = loc1; bmnod(:,ii,M) = loc2;
    for jj = 2:M-1
        locjj = loc1+(loc2-loc1)/(M-1)*(jj-1);
        bmnod(:,ii,jj) = locjj;
        kk = kk + 1;
        bmnodlist(ii,jj) = kk;
        fprintf(fid_nod,'%10d,%12.7e,%12.7e,%12.7e\n',kk,...
            locjj(1),locjj(2),locjj(3));
    end
end

if(iiend==N-1)
    for ii = N:N
        for jj = 1:M
            n1 = line_tip(jj);
            n1_index = find(nod_list==n1);
            loc1 = nod(n1_index,2:end);
            bmnodlist(ii,jj) = n1;
            bmnod(:,ii,jj) = loc1;
        end
    end
end
%% node thickness
for ii = 1:N
thick = Ta+(Tb-Ta)/L(end)*L(ii); 
for jj = 1:M
    n1 = bmnodlist(ii,jj);
    fprintf(fid_thk,'%10d,%12.7e\n',n1,thick);
end
fprintf(fid_mid,'%d\n',bmnodlist(ii,floor((1+M)/2)));
end

%% element
kk = start; Lend = L(end);
for ii = 1:N-1

    density = 1.0e-9;
    nuxy =0.03; nuxz = 0.3; nuyz = 0.3;
    locx = (L(ii)+L(ii+1))/2;
    Ey = Eya+(Eyb-Eya)*locx/Lend;
    Ex = Ey/10; Ez = Ey/10;
    Gxy = Ey/2; Gyz = Gxy; 
    Gxz = Ex/2/(1+nuxz);

    % *Orientation, name=ORI001, DEFINITION=NODES
    % node a, node b, node c
    % normaldirection, angle
    % *shell section, ... orientation=ORI001
    % *Elastic, type=ENGINEERING CONSTANTS
    % 1.,  2.,  3., 0.1, 0.2, 0.3, 10., 20.
    % 30.,   
    nc = bmnodlist(ii,(M+1)/2); 
    nb = bmnodlist(ii,M); 
    na = bmnodlist(ii+1,(M+1)/2);
    fprintf(fid_set,'*elset, elset=bm%010d\n',kk);
    fprintf(fid_sec,'*orientation, name=ori-bm%010d, definition=nodes\n',kk);
    fprintf(fid_sec,'%d,%d,%d\n', na,nb,nc);
    fprintf(fid_sec,'3, 1.0\n');
    fprintf(fid_sec,'*shell section, elset=bm%010d, material=mat-bm%010d, orientation=ori-bm%010d, nodal thickness\n',...
        kk,kk,kk);
    fprintf(fid_mat,'*material, name=mat-bm%010d\n',kk);
    if damping(1)=='s'
        fprintf(fid_mat,'*damping, structural=%10.3e\n',structuraldamping);
    else
        fprintf(fid_mat,'*damping, beta=%10.3e, alpha=%10.3e\n',betadamping, alphadamping);
    end
    fprintf(fid_mat,'*density\n');
    fprintf(fid_mat,'%12.7e\n',density);
    if material(1) == 'o'
        fprintf(fid_mat,'*elastic, type=engineering constants\n');
        fprintf(fid_mat,'%12.7e,%12.7e,%12.7e,%12.7e,%12.7e,%12.7e,%12.7e,%12.7e\n',Ex,Ey,Ez,...
            nuxy,nuxz,nuyz,Gxy,Gxz);
        fprintf(fid_mat,'%12.7e,\n',Gyz);
    else
        fprintf(fid_mat,'*elastic \n');
        fprintf(fid_mat,'%12.7e,%12.7e\n',Ey,nuxz);
    end
    
    for jj=1:M-1
        kk = kk + 1;
        n1 = bmnodlist(ii,jj); n2 = bmnodlist(ii+1,jj);
        n3 = bmnodlist(ii+1,jj+1); n4 = bmnodlist(ii,jj+1);
        fprintf(fid_ele,'%8d,%8d,%8d,%8d,%8d\n',kk,n1,n2,n3,n4);
        fprintf(fid_set,'%10d\n',kk);
    end
end
fclose(fid_nod);
fclose(fid_thk);
fclose(fid_ele);
fclose(fid_set);
fclose(fid_mat);
fclose(fid_sec);
fprintf(1,'Mission Complete !\n');
end