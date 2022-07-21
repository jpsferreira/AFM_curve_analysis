%input: x, y are vectors of data

%output: coefficients of fitted curve y = kx + b
%coeff(1) = b
%coeff(2) = k

function coeff = linearFit(x,y)
X = [ones(length(x),1), x];
coeff = X\y;
end