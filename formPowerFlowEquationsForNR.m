function equations=formPowerFlowEquationsForNR(Y, nodes,p,q,v, slack)

numberOfNodes=length(nodes);

%create symbolic variables
vars = cat(2,sym('phi_',[1 numberOfNodes]),sym('v_', [1,numberOfNodes]));

%create arrays of unknown values
xangle=[];
xv=[];
for i=1:numberOfNodes
    xangle=[xangle vars(i)];
    xv=[xv vars(i+numberOfNodes)];
end

%create equations
equations=[];
for i=1:numberOfNodes
    if nodes(i)=="sl"
        fp=xangle(i)-angle(slack);
        fq=xv(i)-abs(slack);
        equations=[equations;fp;fq];
    elseif nodes(i)=="pv"
        fp=-p(i);
        for j=1:numberOfNodes
            if j==i
                fp=fp+xv(i)^2*abs(Y(i,i))*cos(angle(Y(i,i)));
            else
                fp=fp+xv(i)*abs(Y(i,j))*xv(j)*cos(xangle(i)-angle(Y(i,j))-xangle(j));
            end
        end
        fq=xv(i)-v(i);
        equations=[equations;fp;fq];
        
    elseif nodes(i)=="pq"
        fp=-p(i);
        fq=-q(i);
        for j=1:numberOfNodes
            if j==i
                fp=fp+xv(i)^2*abs(Y(i,i))*cos(angle(Y(i,i)));
                fq=fq-xv(i)^2*abs(Y(i,i))*sin(angle(Y(i,i)));
            else
                fp=fp+xv(i)*abs(Y(i,j))*xv(j)*cos(xangle(i)-angle(Y(i,j))-xangle(j));
                fq=fq+xv(i)*abs(Y(i,j))*xv(j)*sin(xangle(i)-angle(Y(i,j))-xangle(j));
            end
        end
        equations=[equations;fp;fq];
    end
end


end