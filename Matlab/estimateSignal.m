function [ x_hat ] = estimateSignal( Y )
%ESTIMATESIGNAL Recontructs an estimate of the signal from its STFT
%   Detailed explanation goes here
    N = (length(Y)-1)/2;    % # of samples in spectrogram
    Y = [Y; flipud(conj(Y))];
    q = real(ifft(Y));
    q = q(1:N,:);
    q = spacedelay(q,N/2-1);
    q = sum(q,2);
    q(N/2+1:length(q)-N/2-1) = q(N/2+1:length(q)-N/2-1)/2;
    x_hat = q;
end