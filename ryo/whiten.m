function [X] = whiten(X)
% Patrick Mineault's whiten.m 
X = bsxfun(@minus,X,mean(X));
A = X'*X;
[V,D] = eig(A);
X = X*V*diag(1./(diag(D)+eps).^(1/2))*V';
end