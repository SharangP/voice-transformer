function [warpedStft ] = timeWarp( target, source, window, overlap, nfft )
%TIMEWARP Summary of this function goes here
%   Detailed explanation goes here

%Construct the 'local match' scores matrix as the cosine distance 
% between the STFT magnitudes
stfMag = simmx(abs(target), abs(source));

% Use dynamic programming to find the lowest-cost path between the 
% opposite corners of the cost matrix
% Note that we use 1-SM because dp will find the *lowest* total cost
[p,q,C] = dp2(1-stfMag);

% Calculate the frames in source that are indicated to match each frame
% in target, so we can resynthesize a warped, aligned version
warping = zeros(1, size(target,2));
for i = 1:length(warping); warping(i) = q(find(p >= i, 1 )); end

% Phase-vocoder interpolate D2's STFT under the time warp
warpedStft = pvsample(source, warping-1, window-overlap);
% Invert it back to time domain
% warpedSig = istft(warpedStft, nfft, window, window-overlap)';


end

