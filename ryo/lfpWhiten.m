function SX = lfpWhiten(X)
W = whiten(X); 
SX = W./sqrt(var(W(:))+sum(var(W))*1e-5);
end