function tospiral(spiral_or_not)
    folder = textread('__dic.log','%s'); folder = folder{1};
    nod = load([folder,'/model_node.cnn']);
    fid = fopen([folder,'/model_node_spiral.cnn'],'w');
    list = nod(:,1);
    nod = nod(:,2:4);
    locspr = nod;
    L = 35; r1 = L/3/pi;
    theta1 = -pi/2; dtheta=5*pi; theta2=theta1+dtheta;
    temp = [1 theta1; dtheta (theta2^2-theta1^2)/2]\[r1;L];
    a=temp(1); b=temp(2);
    r2=a+b*theta2;
    xc=r1*cos(theta1); yc=r1*sin(theta1);
    for ii=1:size(nod,1)
    x = nod(ii,1);
    if(x>=0)
        y=nod(ii,2);
        theta=(-a+sqrt(a^2+2*b*(a*theta1+b/2*theta1^2+x)))/b;
        r = a+b*theta;
        locspr(ii,1)=r*cos(theta)-y*cos(theta)-xc;
        locspr(ii,2)=r*sin(theta)-y*sin(theta)-yc;
        locspr(ii,3)=locspr(ii,3)+x/L*3.5;
    end
    if spiral_or_not==1
        fprintf(fid,'%d,%f,%f,%f\n',list(ii),locspr(ii,1),locspr(ii,2),locspr(ii,3));
    else
        fprintf(fid,'%d,%f,%f,%f\n',list(ii),nod(ii,1),nod(ii,2),nod(ii,3));
    end
    end
    fclose(fid);
    fprintf(1,'Mission Complete\n');
end