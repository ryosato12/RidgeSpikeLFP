function [numCross,trainInds,testInds] = lapPartition1d(lapID)
numCross = 2;
isValid = lapID(:,1)~=0; 
trainInds = isValid & (mod(lapID(:,1),2) & lapID(:,2)==1);
testInds = false(size(lapID,1),numCross);
for i = 1:numCross
    testInds(:,i) = isValid & mod(lapID(:,1),2)==0 & lapID(:,2)==i;
end
end