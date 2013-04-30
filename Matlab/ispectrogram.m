function [ y ] = ispectrogram(S,window, overlap)
% ispectrogram calculates the inverse spectrogram of 1024 pt xform
% overlap = 128


% make sure this only happens for real signals (check size of S)
X = [S;flipud(conj(S(2:(size(S,1)-1),:)))];

chunk = window-overlap;
Y = real(ifft(X));
y1 = [Y(1:chunk,:) Y(end-chunk+1:end)'];
y2 = [Y(1:chunk)' Y(overlap:window-1,:)];
y = mean([reshape(y1,1,[]) ; reshape(y2,1,[])],1)';

end

