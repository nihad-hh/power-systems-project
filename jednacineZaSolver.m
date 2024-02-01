parametriLinija;
numberOfNodes=size(Y,1);
vars = cat(2,sym('phi_',[1 numberOfNodes]),sym('v_', [1,numberOfNodes]));

slack = 1.04 + 1i*0;
nodes=["sl", "pv", "pv", "pq", "pq", "pq", "pq","pq", "pq"];
p=[0, 1.63, 0.85, 0, -1.25, -0.9, 0, -1, 0];
q=[0, 0, 0, 0, -0.5, -0.3, 0, -0.35, 0];
v=[1.04, 1.025, 1.025, 0, 0, 0, 0, 0, 0];

equations=formPowerFlowEquationsForNR(Y, nodes,p,q,v, slack);

digits(8);
expr=string(vpa(equations,8));
for i=1:length(expr)
    fprintf("<Eq fx=""%s""/>\n" , expr(i));
end
digits(32);