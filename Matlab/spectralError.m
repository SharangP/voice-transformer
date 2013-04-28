function [ mse ] = spectralError(sig1, sig2, fs, etype)
%spectralError determines the mean squared error between the spectrograms of two
%signals
%   [ mse ] = spectralError(sig1, sig2, fs, etype)
%   etype = 1 ret

window = 512;
overlap = 256;
nfft = 512;

if (nargin > 3) && (etype ~= 1) && (etype ~= 2)
    err = MException('ResultChk:OutOfRange','etype can only be 1 or 2');
    throw(err);
elseif nargin <3 
    etype = 1;
end

if(size(sig1,2) > size(sig1,1))
    sig1 = sig1';
end
if(size(sig2,2) > size(sig2,1))
    sig2 = sig2';
end

if length(sig1) < length(sig2)
    sig1 = padarray(sig1,length(sig2)-length(sig1),'post');
else
    sig2 = padarray(sig2,length(sig1)-length(sig2),'post');
end


spec1 = abs(spectrogram(sig1,window,overlap,nfft,fs));
spec2 = abs(spectrogram(sig2,window,overlap,nfft,fs));

mse = mean((spec1-spec2).^2,etype);

end

