function cochlea_model_2d_create_mesh(file)
    %% theis function try to create a 2D mesh as ADINA
    L = 0.035; HaSV = 0.001; HbSV = 0.0005; HaST = 0.001; HbST = 0.0005;
    Heli = 0.0005;
    % definition of points
    points.loc=[0,-HaST;        % point 1
                0,-0.00005;            % point 2
                0,0.00005;            % point 3
                0,HaSV;         % point 4
                L,-HbST;        % point 5
                L,0;            % point 6
                L,HbST;         % point 7
                L+Heli,-HbST;   % point 8
                L+Heli, 0;      % point 9
                L+Heli, HbSV];  % point 10
    lines.point=[1,5;  % line 1
                2,6;    % line 2
                3,6;    % line 3
                4,7;    % line 4
                5,8;    % line 5
                6,9;    % line 6
                7,10;   % line 7
                1,2;    % line 8
                5,6;    % line 9
                8,9;    % line 10
                3,4;    % lien 11
                6,7;    % line 12
                9,10];  % line 13
    surfs.line=[1,9,2,8;   % surf 1
                3,12,4,11;  % surf 2
                5,10,6,9;   % surf 3
                6,13,7,12]; % surf 4
    lines.ori = zeros(size(lines.point,1),1);
    surfs.ori = 0*surfs.line;
    points.no= size(points.loc,1);
    lines.no = size(lines.point,1);
    surfs.no = size(surfs.line,1);
    % divisions should be of same length of no. of lines
    lines.division =[256,256,256,256,5,5,5,10,10,10,10,10,10];
    %% analyze the geometry
    % check for line and points
    points.used = zeros(points.no,1);
    for ii = 1:lines.no
        points.used(lines.point(ii,:)) = points.used(lines.point(ii,:))+1;
    end
    if ~isempty(find(points.used<=1))
        fprintf('not all points been used !\n');
    end
    % check for surf and lines
    lines.used = zeros(lines.no,1);
    for ii = 1:surfs.no
        lines.used(surfs.line(ii,:))=lines.used(surfs.line(ii,:))+1;
    end
    if ~isempty(find(lines.used<1))
        fprintf('not all lines been used !\n');
    end
    % check for surf lines orientation
    for kk = 1:surfs.no
        tmp = surfs.line(kk,:);
        pts = lines.point(tmp,:);
        pts = [pts;pts(1,:)];
        for ii = 1:length(tmp)
            n11 = pts(ii,1); n12 = pts(ii,2);
            n21 = pts(ii+1,1); n22 = pts(ii+1,2);
            if n12 == n21 || n12 == n22
                surfs.ori(kk,ii) = 1;
                lines.ori(tmp(ii)) = 1;
            end
            if n11 == n21 || n11 == n22
                surfs.ori(kk,ii) = -1;
                lines.ori(tmp(ii)) = -1;
                pts(ii,1:2) = pts(ii,2:-1:1);
            end
        end
        if ~isempty(find(surfs.ori(kk,:)==0))
            fprintf('problems in surfs orientation\n');
        end
        for ii = 1:length(tmp)-1
            L1 = points.loc(pts(ii,2),:)-points.loc(pts(ii,1),:);
            L2 = points.loc(pts(ii+1,2),:)-points.loc(pts(ii+1,1),:);
            if L1(1)*L2(2)-L1(2)*L2(1)<=0
                fprintf('problems in surfs orientation, negtive\n');
            end
        end
    end
    
    %% Check for mapping
    for kk = 1:surfs.no
        tmp = surfs.line(kk,:);
        if lines.division(tmp(1))~=lines.division(tmp(3)) ...
            || lines.division(tmp(2))~=lines.division(tmp(4))
            fprintf('problems in surfs (surf. %d) mapping \n',kk);
            return;
        end
    end
    
    %% evaluation
    nnod = 0;
    nele = 0;
    for kk = 1:surfs.no
        tmp = surfs.line(kk,:);
        M = lines.division(tmp(1));
        N = lines.division(tmp(2));
        nnod = nnod+(M+1)*(N+1);
        nele = nele+M*N;
    end
    
    %% mesh
    nod = zeros(nnod,2);
    ele = zeros(nele,4);
    % points mesh
    nodkk = 0; elekk = 0;
    nod(nodkk+(1:points.no),:) = points.loc;
    points.nodid = nodkk+(1:points.no);
    nodkk = nodkk + points.no;
    
    % line mesh
    for kk = 1:lines.no
        p1 = lines.point(kk,1);
        p2 = lines.point(kk,2);
        if lines.ori(kk) == -1;
            tmp = p1; p1 = p2; p2 = tmp;
        end
        N = lines.division(kk);
        loc1 = points.loc(p1,:);
        loc2 = points.loc(p2,:);
        nod(nodkk+(1:N-1),:) = loc1+(1:N-1)'*(loc2-loc1)/N;
        lines.nodid{kk} = [p1 nodkk+(1:N-1) p2];
        nodkk = nodkk + N-1;
    end
    
    % sufrace mesh
    for kk = 1:surfs.no
        tmp = surfs.line(kk,:);
        L1 = tmp(1); L2 = tmp(2); L3 = tmp(3); L4 = tmp(4);
        L1nod = lines.nodid{L1};
        L2nod = lines.nodid{L2};
        L3nod = lines.nodid{L3};
        L4nod = lines.nodid{L4};
        if( surfs.ori(kk,1)*lines.ori(L1) == -1) L1nod = L1nod(end:-1:1); end
        if( surfs.ori(kk,2)*lines.ori(L2) == -1) L2nod = L2nod(end:-1:1); end
        if( surfs.ori(kk,3)*lines.ori(L3) ==  1) L3nod = L3nod(end:-1:1); end
        if( surfs.ori(kk,4)*lines.ori(L4) ==  1) L4nod = L4nod(end:-1:1); end
        M = length(L1nod); N = length(L2nod);
        
        nodtopo = zeros( M,N );
        nodtopo(:,1) = L1nod;
        nodtopo(:,N) = L3nod;
        nodtopo(1,:) = L4nod;
        nodtopo(M,:) = L2nod;
        for jj = 2:N-1
            a1 = nod(L4nod(jj),:);
            a2 = nod(L2nod(jj),:);
            a = a2-a1;
            for ii = 2:M-1
                b1 = nod(L1nod(ii),:);
                b2 = nod(L3nod(ii),:);
                b = b2-b1;
                c = b1-a1;
                t = c(1)*b(2)-c(2)*b(1);
                t = t/(a(1)*b(2)-a(2)*b(1));
                nod(nodkk+1,:) = a1+t*a;
                nodkk = nodkk + 1;
                nodtopo(ii,jj) = nodkk;
            end
        end
        
        for jj = 1:N-1
            for ii = 1:M-1
                ele(elekk+1,:) = [nodtopo(ii,jj),nodtopo(ii+1,jj),nodtopo(ii+1,jj+1),nodtopo(ii,jj+1)];
                elekk = elekk+1;
            end
        end
    end
    nod = nod(1:nodkk,:);
    ele = ele(1:elekk,:);
    figure(1); hold on;
    patch('Faces',ele,'Vertices',nod,'facecolor','g');
    figure(2); hold on;
    for ii = 1:lines.no
        tmp = points.loc(lines.point(ii,:),:);
        if lines.used(ii) == 1
            plot(tmp(:,1),tmp(:,2),'bo-','linewidth',2);
            mid = (tmp(1,:)+tmp(2,:))/2;
            text(mid(1),mid(2),num2str(ii),'color','r'); 
        else
            plot(tmp(:,1),tmp(:,2),'g-','linewidth',1);
        end
    end
    save(file,'nod','ele','lines');
end