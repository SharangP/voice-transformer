% Voice Transformer
% Sharang Phadke
% Sameer Chocotaco
% 
% Looking at things
clear all;close all;
TSPpath = '../../TSPspeech/48k/';

MAsoundFiles = dir(strcat(TSPpath, 'MA/*.wav'));
FAsoundFiles = dir(strcat(TSPpath, 'FA/*.wav'));

[signal1M, fs] = wavread(strcat(TSPpath,'MA/', MAsoundFiles(1).name));
[signal1F, ~] = wavread(strcat(TSPpath,'FA/', FAsoundFiles(1).name));

signal1M = signal1M(1:ceil(length(signal1M)/4));
signal1F = signal1F(1:ceil(length(signal1F)/4));

sig1M = Signal(strcat(TSPpath,'MA/', MAsoundFiles(1).name));
sig1F = Signal(strcat(TSPpath,'FA/', FAsoundFiles(1).name));
sig1M.s = sig1M.s(1:ceil(length(sig1M.s)/4));
sig1F.s = sig1F.s(1:ceil(length(sig1F.s)/4));

sig1Xform =  Signal(strcat(TSPpath,'FA/', FAsoundFiles(1).name));


% nFFT >= window
nFFT = 512;
% winTime = 0.01;
window = 128;
overlap = 64;

% Time warping female signal
sig1M.nfft =nFFT;
sig1F.nfft= nFFT;
sig1M.STFT;
sig1F.STFT;
warpedSTFT = timeWarp(sig1M.S,sig1F.S,sig1F.windowLength,sig1F.overlapRatio*sig1F.windowLength,sig1F.nfft);sig1F.S = warpedSTFT;
sig1M.S = warpedSTFT;
signal1FWarp = sig1M.iSTFT();

sig1M.s = signal1M;
sig1F.s = signal1FWarp;

sig1M.STFT;
sig1F.STFT;

% Spectrogram stuff for changing freqs
freqs1M = abs(spectrogram(signal1M,window,overlap,nFFT,fs));
freqs1F = abs(spectrogram(signal1FWarp,window,overlap,nFFT,fs));

% [signal1FW,freqs1FW] = timeWarp(freqs1M,freqs1F,window,overlap,nFFT);
% freqs1M = abs(sig1M.S);
% freqs1F = abs(sig1F.S);

%% Fit GMMs to Sourcea and Target Spectra

gmmSource = cell(size(freqs1F,1),1);
gmmTarget = cell(size(freqs1M,1),1);
gmmJoint = cell(size(freqs1M,1),1);

for n = 1:size(freqs1F,1)
    nCluster = 2;
    gmmSource{n} = gmdistribution.fit(freqs1F(n,:)',nCluster);
    while (gmmSource{n}.Converged ~=  1) && (nCluster > 1)
        nCluster = nCluster - 1;
        gmmSource{n} = gmdistribution.fit(freqs1F(n,:)',nCluster,'Regularize',1e-6);
    end
    gmmTarget{n} = gmdistribution.fit(freqs1M(n,:)',nCluster,'Regularize',1e-6);
    gmmJoint{n} = gmdistribution.fit([freqs1F(n,:)';freqs1M(n,:)'],nCluster,'Regularize',1e-6);
end

%% Apply the Transformation Function

freqsTransformed = zeros(size(freqs1F));
freqsTransformed2 = zeros(size(freqs1M));

for n = 1:size(freqs1F,1) 
    n
    muX = gmmSource{n}.mu;
    sigmaX = gmmSource{n}.Sigma;
    sigmaX = reshape(sigmaX,numel(sigmaX),1);
    
    muY = gmmTarget{n}.mu;
    sigmaY = gmmTarget{n}.Sigma;
    sigmaY = reshape(sigmaY,numel(sigmaY),1);
        
    sigmaXY = gmmJoint{n}.Sigma;
    sigmaXY = reshape(sigmaXY,numel(sigmaXY),1);
    
    for m = 1:size(freqs1F,2)
        h = gmmSource{n}.posterior(freqs1F(n,m))';
        freqsTransformed(n,m) = sum(h.*(muY + sigmaXY.*(sigmaX.^-1).*(freqs1F(n,m) - muX)));
    end
    
    for m = 1:size(freqs1M,2)
        h = gmmTarget{n}.posterior(freqs1M(n,m))';
        freqsTransformed2(n,m) = sum(h.*(muY + sigmaY.*(sigmaY.^-1).*(freqs1M(n,m) - muY)));
    end
end


% sig1Xform.S = freqsTransformed;
% xFormed = sig1Xform.iSTFT();
xFormed = ispectrogram(freqsTransformed,window,overlap); 
xFormed2 = ispectrogram(freqsTransformed2,window,overlap);

% xFormed = istft(freqsTransformed, nFFT, winTime*fs,  winTime*fs/2)';
% xFormed = timeWarp(freqs1M, freqsTransformed, winTime*fs, winTime*fs/2, nFFT);

%% DTF 
% %  
%


spec1M = spectrogram(signal1M,window,overlap,nFFT,fs);
spec1F = spectrogram(signal1F,window,overlap,nFFT,fs);

% Dynamic Time warping

%Construct the 'local match' scores matrix as the cosine distance 
% between the STFT magnitudes
stfMag = simmx(abs(spec1M), abs(spec1F));

% Use dynamic programming to find the lowest-cost path between the 
% opposite corners of the cost matrix
% Note that we use 1-SM because dp will find the *lowest* total cost
[p,q,C] = dp2(1-stfMag);

% Calculate the frames in spec1F that are indicated to match each frame
% in spec1M, so we can resynthesize a warped, aligned version
female1 = zeros(1, size(spec1M,2)');
% masterMVN = prtRvGmm('nComponents',3);
% masterMVN.train(masterMDS);
% 
% for n = 1:size(freqs1M,1)
%     n
%     ds(n) = prtDataSetClass(freqs1M(n,:)');
%     gmm1M(n).mle(ds(n));
% end(freqs1M,2));
for i = 1:length(female1); female1(i) = q(find(p >= i, 1 )); end
% Phase-vocoder interpolate D2's STFT under the time warp
femaleInterp = pvsample(spec1F, female1-1, window-overlap);
% Invert it back to time domain
% femaleWarp = istft(femaleInterp, 512, 512, 128)';
femaleWarp = istft(femaleInterp, nFFT, window, window-overlap)';
% femaleWarp = padarray(femaleWarp,length(signal1M)-length(femaleWarp),'post');

soundsc([femaleWarp],fs);




%% FURKKKK
% 
% gmm1M = prtRvMvn;
% gmm1M = repmat(gmm1M, size(freqs1M,1),1);
% ds = repmat(prtDataSetClass,size(freqs1M,1),1);
% masterMDS = prtDataSetClass(freqs1M');
% masterMVN = prtRvGmm('nComponents',3);
% masterMVN.train(masterMDS);
% 
% for n = 1:size(freqs1M,1)
%     n
%     ds(n) = prtDataSetClass(freqs1M(n,:)');
%     gmm1M(n).mle(ds(n));
% end


% 
% freqs1FN = bsxfun(@rdivide, bsxfun(@minus, freqs1F , mu1F), var1F);
% freqs1FtoM = bsxfun(@plus, bsxfun(@times, freqs1FN, var1M), mu1M);
% 
% x = ifft(freqs1FtoM);
% x = reshape(smooth(real(x)),1,numel(x));
% soundsc(x,fs);
% soundsc(reshape(ifft(freqs1M),1,numel(framedSig1M)),fs);
%
%
%
%
%

%
%

%
%
%

%
%
%
%

%
%

%
%

%
%
%

%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%

%
%
%
%

%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%




%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

%
%
%
%

%

%
%
%
%

%
%
%

%
%

%


%
%
%

%
%

%
%

% OUR ENTIRE CODE IS COMMENTS
%
