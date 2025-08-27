function B = lfpWhitenRegress(XX,YX,lambda)
B = (XX+lambda*eye(XX,1))\YX.'; 
end 