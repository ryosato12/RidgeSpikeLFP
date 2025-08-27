function SX = normalize(X)
mu = mean(X);
sigma2 = std(X);
sigma2(sigma2 < eps) = 1;
SX = X-repmat(mu,[size(X,1) 1]);
SX = SX./repmat(sigma2,[size(X,1) 1]);
end 