function [Y] = anti_diag_avg(M)
M = fliplr(M);

[h, w] = size(M);

Y = zeros(1, w+h-1);
for i=-h+1:w-1
    Y(w-i) = mean(diag(M, i));
end

end

