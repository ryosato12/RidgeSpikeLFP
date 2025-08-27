function output = regressConvolve2(Y,X,lapID,Fs,lambdas,penalty) 
% REGRESSCONVOLVE2 Fast CWT before regression
%  output = regressConvolve2(Y,X,lapID,Fs,lambdas,penalty)
%  convolves Y and X with a complex Morlet wavelet and passes to
%  ridge/LASSO regression. 

% Padding
win = 1024;
inds = imdilate(lapID(:,4)==1,ones(win/2+1,1)); 
Y = Y(inds,:);
X = X(inds,:);
lapID = lapID(inds,:);
inds = lapID(:,4)==1;

% Assumes 1D position
[numCross,trainInds,testInds] = lapPartition1d(lapID(inds,:)); 

% Builds complex Morlet wavelet 
voices = 2;
% [lb,ub] = cwtfreqbounds(win,Fs,Wavelet="amor",cutoff=100*1e-8/2); 
% Fl = [lb,ub]; 
Fl = [4 (Fs*.5)*.8]; 
Fb = cwtfilterbank(SamplingFrequency=Fs,VoicesPerOctave=voices, ...
    FrequencyLimits=Fl,SignalLength=win,Wavelet="amor"); 
f = centerFrequencies(Fb);
psis = wavelets(Fb); 

[mx,nx] = size(X); 
[~,nm] = size(psis); 
if (mx <= nm) | (nx <= 1)  
    error("Wavelet must be smaller than the data.") 
end 

for i = 1:size(psis,1)    
    psi = psis(i,:).'; 

    % Convolution 
    cY = convolve2(Y,psi,"same"); 
    cX = convolve2(X,psi,"same"); 

    % Runs regression
    [mdlErr,Betas,spectra] = regressPredict(cY(inds,:),cX(inds,:), ...
        lambdas,penalty,numCross,trainInds,testInds);

    output.bands(i) = struct("frequency",f(i), ...
        "mdlErr",mdlErr,"Betas",Betas,"spectra",spectra);
end

output.frequencies = f; 

end