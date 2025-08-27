function B = ridgeCov(XX,YX,lambda)
% RIDGECOV Complex ridge solved with diag(max(1,diag(X^*X))) instead of the
% identity matrix. 

Gamma = diag(max(1,diag(XX)));
B = (XX+lambda*Gamma)\YX.'; 

end 
