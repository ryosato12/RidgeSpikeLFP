function [mdlErr,Betas,spectra] = regressPredict(Y,X,lambdas,penalty,numCross,trainInds,testInds) % bootstrap(?)
% REGRESSPREDICT Cross-validated ridge/LASSO
%  [mdlErr,Betas,spectra] = regressPredict(Y,X,lambdas,penalty,numCross,
%  trainInds,testInds) returns model error (Pearson's R, MSE, and R^2), 
%  regression coefficients, and the test and predicted variances of the 
%  output.

% Initialize
r = zeros(numCross,numel(lambdas),size(Y,2));
MSE = r;
rSquared = MSE;

Betas = zeros(numel(lambdas),size(X,2),size(Y,2)); 

testVar = zeros(numCross,size(Y,2));
predVar = zeros(numel(lambdas),numCross,size(Y,2));

if penalty == "whiten"
    X = lfpWhiten(X); 
end

xTrain = X(trainInds,:); 
yTrain = Y(trainInds,:);

XX = xTrain'*xTrain; 
YX = yTrain'*xTrain; 

switch penalty
    case "l1"
        solver = @(lambda) lassoFISTA(XX,YX,lambda);
    case "l2"
        solver = @(lambda) ridgeCov(XX,YX,lambda);
    case "whiten"
        solver = @(lambda) lfpWhitenRegress(XX,YX,lambda); 
end

for i = 1:numel(lambdas)

    % Estimates regression coefficients
    Beta = solver(lambdas(i));
    Betas(i,:,:) = Beta;

    for j = 1:numCross

        xTest = X(testInds(:,j),:);
        yTest = Y(testInds(:,j),:); 
        
        yPred = xTest*conj(Beta);

        % Pearson's R
        r(i,j,:) = diag(corr(yTest,yPred));
        
        % Mean squared Error
        MSE(i,j,:) = mean(abs(yTest-yPred).^2); % /max(.001,std(yTest(:))); 

        % R^2 
        SSE = sum(abs(yTest-yPred).^2); 
        SST = sum(abs(yTest-mean(yTest)).^2); 
        rSquared(i,j,:) = 1-SSE./(SST+1e-5);
        
        testVar(j,:) = var(yTest,1,1); 
        predVar(i,j,:) = var(yPred,1,1); 

    end 

end 

mdlErr = struct("r",r,"MSE",MSE,"rSquared",rSquared); 
spectra = struct("true",testVar,"pred",predVar); 

end