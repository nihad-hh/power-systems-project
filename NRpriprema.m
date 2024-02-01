% Kreiranje matrice admitansi pogodne za tokove snaga

Y=[1, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 1/Z27, 0, 0, 0, 0, -1/Z27, 0, 0;
    0, 0, 1/Z39, 0, 0, 0, 0, 0, -1/Z39;
    -1/Z14, 0, 0, 1/Z14 + 1/Z45 + 1/Z46 + Y45 + Y46, -1/Z45, -1/Z46, 0, 0, 0;
    0, 0, 0, -1/Z45, 1/Z45 + 1/Z57 + Y45 + Y57 , 0, -1/Z57, 0, 0;
    0, 0, 0, -1/Z46, 0, 1/Z46 + 1/Z69 + Y46 + Y69, 0, 0, -1/Z69;
    0, -1/Z27, 0, 0, -1/Z57, 0, 1/Z27 + 1/Z57 + 1/Z78 + Y78 + Y57, -1/Z78, 0;
    0, 0, 0, 0, 0, 0, -1/Z78, 1/Z78 + 1/Z89 + Y78 + Y89, -1/Z89;
    0, 0, -1/Z39, 0, 0, -1/Z69, 0, -1/Z89, 1/Z39 + 1/Z69 + 1/Z89 + Y89 + Y69];


% Kreiranje 18 simboličkih varijabli za 18 nepoznatih:
vars = cat(2,sym('phi_',[1 9]),sym('v_', [1,9]));
for i=1: size(vars, 2)
    syms(vars(i));
end

% Formiranje početne tačke na osnovu podataka za slack:
v_slack1 = v1 + 1i*0;
x0=[];
for i=1:9
    x0=[x0; angle(v_slack1)];
end
for i=1:9
    x0=[x0; abs(v_slack1)];
end

%Nepoznate i poznate vrijednosti:
xangle=[phi_1,phi_2,phi_3,phi_4,phi_5,phi_6,phi_7,phi_8,phi_9];
xv=[v_1,v_2,v_3,v_4,v_5,v_6,v_7,v_8,v_9];
nodes=["sl", "pv", "pv", "pq", "pq", "pq", "pq","pq", "pq"];
p=[0, p2, p3, 0, p5, p6, 0, p8, 0];
q=[0, 0, 0, 0, q5, q6, 0, q6, 0];
v=[v1, v2, v3, 0, 0, 0, 0, 0, 0];

%Formiranje jednačina:
equations=[];
for i=1:9
    if nodes(i)=="sl"
        fp=xangle(i)-angle(v_slack1);
        fq=xv(i)-abs(v_slack1);
        equations=[equations;fp;fq];
    elseif nodes(i)=="pv"
        fp=-p(i);
        for j=1:9
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
        for j=1:9
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

% Prikaz dobijenih jednačina:
if(prikaz_jednacina == 1)
    vpa(equations,4)
end
