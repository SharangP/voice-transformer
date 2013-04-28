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

nFFT = 128;
winTime = 0.01;
freqs1M = abs(spectrogram(signal1M,winTime*fs,winTime*fs/2,nFFT,fs));
freqs1F = abs(spectrogram(signal1F,winTime*fs,winTime*fs/2,nFFT,fs));

% %% DTF 
% %  
% spec1M = spectrogram(signal1M,512,384,512,fs);
% spec1F = spectrogram(signal1F,512,384,512,fs);
% 
% %% Dynamic Time warping
% 
% %Construct the 'local match' scores matrix as the cosine distance 
% % between the STFT magnitudes
% stfMag = simmx(abs(spec1M), abs(spec1F));
% 
% % Use dynamic programming to find the lowest-cost path between the 
% % opposite corners of the cost matrix
% % Note that we use 1-SM because dp will find the *lowest* total cost
% [p,q,C] = dp2(1-stfMag);
% 
% % Calculate the frames in spec1F that are indicated to match each frame
% % in spec1M, so we can resynthesize a warped, aligned version
% female1 = zeros(1, size(spec1M,2));
% for i = 1:length(female1); female1(i) = q(find(p >= i, 1 )); end
% % Phase-vocoder interpolate D2's STFT under the time warp
% femaleInterp = pvsample(spec1F, female1-1, 128);
% % Invert it back to time domain
% femaleWarp = istft(femaleInterp, 512, 512, 128)';
% % femaleWarp = padarray(femaleWarp,length(signal1M)-length(femaleWarp),'post');
% 
% % soundsc(femaleWarp,fs);
%% Fit GMMs to Sourcea and Target Spectra

gmmSource = cell(size(freqs1F,1),1);
gmmTarget = cell(size(freqs1M,1),1);
gmmJoint = cell(size(freqs1M,1),1);

for n = 1:size(freqs1F,1)
    nCluster = 5;
    gmmSource{n} = gmdistribution.fit(freqs1F(n,:)',nCluster);
    while (gmmSource{n}.Converged ~=  1) && (nCluster > 1)
        nCluster = nCluster - 1;
        gmmSource{n} = gmdistribution.fit(freqs1F(n,:)',nCluster);
    end
    gmmTarget{n} = gmdistribution.fit(freqs1M(n,:)',nCluster);
    gmmJoint{n} = gmdistribution.fit([freqs1F(n,:)';freqs1M(n,:)'],nCluster);
end

%% Apply the Transformation Function

freqsTransformed = zeros(size(freqs1F));

for n = 1:size(freqs1F,1)    
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
end

 xFormed = istft(freqsTransformed, nFFT, winTime*fs,  winTime*fs/2)'

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
