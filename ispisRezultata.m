if conv == 0
    fprintf('Algoritam ne konvergira u %d iteracija sa zadanom preciznoscu od %g .\n', maxNumberOfIter, eps);
else
    fprintf('Algoritam konvergira u %d iteracija sa greskom od %g .\n\n', iter, err);
end

x(1:9)=x(1:9)*360/(2*pi);

for i=1:9
    arrayfun(@(i, x, y) fprintf('v%d: %.3f < %.2f°\n', i, x, y), i, x(9+i), x(i), 'uni', 0);
end