function [val] = evaluateSymMatrix(matrix, vars, args)
[m, n] = size(matrix);
val    = zeros(m, n);
for i = 1 : m
    for j = 1 : n
        val(i, j) = double(subs(matrix(i, j), vars, args'));
        %val(i, j) = vpa(subs(matrix(i, j), vars, args'));
    end
end
end

