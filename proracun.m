Z14=0+1i*0.0576;
Z27=0+1i*0.0625;
Z39=0+1i*0.0586;
Z45=0.01+1i*0.085;
Z46=0.017+1i*0.092;
Z57=0.032+1i*0.161;
Z69=0.039+1i*0.17;
Z78=0.0085+1i*0.072;
Z89=0.0119+1i*0.1008;

Y78=0+1i*0.0745;
Y89=0+1i*0.1045;
Y57=0+1i*0.153;
Y69=0+1i*0.179;
Y45=0+1i*0.088;
Y46=0+1i*0.079;

% create admittance matrix
Y=[1, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 1/Z27, 0, 0, 0, 0, -1/Z27, 0, 0;
    0, 0, 1/Z39, 0, 0, 0, 0, 0, -1/Z39;
    -1/Z14, 0, 0, 1/Z14 + 1/Z45 + 1/Z46 + Y45 + Y46, -1/Z45, -1/Z46, 0, 0, 0;
    0, 0, 0, -1/Z45, 1/Z45 + 1/Z57 + Y45 + Y57 , 0, -1/Z57, 0, 0;
    0, 0, 0, -1/Z46, 0, 1/Z46 + 1/Z69 + Y46 + Y69, 0, 0, -1/Z69;
    0, -1/Z27, 0, 0, -1/Z57, 0, 1/Z27 + 1/Z57 + 1/Z78 + Y78 + Y57, -1/Z78, 0;
    0, 0, 0, 0, 0, 0, -1/Z78, 1/Z78 + 1/Z89 + Y78 + Y89, -1/Z89;
    0, 0, -1/Z39, 0, 0, -1/Z69, 0, -1/Z89, 1/Z39 + 1/Z69 + 1/Z89 + Y89 + Y69];

% create 18 symbolic variables
vars = sym('x',[1 18]);
for i=1: size(vars, 2)
    syms(vars(i));
end

% set initial guess values
v_slack1 = 1.04 + 1i*0;
x0=[];
for i=1:9
    x0=[x0; angle(v_slack1)];
end
for i=1:9
    x0=[x0; abs(v_slack1)];
end

xangle=[x1,x2,x3,x4,x5,x6,x7,x8,x9];
xv=[x10,x11,x12,x13,x14,x15,x16,x17,x18];
nodes=["sl", "pv", "pv", "pq", "pq", "pq", "pq","pq", "pq"];
p=[0, 1.63, 0.85, 0, -1.25, -0.9, 0, -1, 0];
q=[0, 0, 0, 0, -0.5, -0.3, 0, -0.35, 0];
v=[1.04, 1.025, 1.025, 0, 0, 0, 0, 0, 0];

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
%equations1=vpa(equations,4);

maxNumberOfIter = 10;
eps             = 10^(-9);
[x, err, iter, conv] = NR(equations, vars, maxNumberOfIter, eps, x0);
if conv == 0
    fprintf('Algoritam ne konvergira u %d iteracija sa zadanom preciznoscu od %d.\n', maxNumberOfIter, eps);
else
    fprintf('Algoritam konvergira u %d iteracija sa greskom od %d.\n', iter, err);
end

x(1:9)=x(1:9)*360/(2*pi);

for i=1:9
    arrayfun(@(x, y) fprintf('%.3f < %.2f°\n', x, y), x(9+i), x(i), 'uni', 0);
end


