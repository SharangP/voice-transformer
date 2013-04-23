function [wavs,fs] = load_wavs(directory)
% LOAD_WAVS Loads all wavs in the current directory.
%
% LOAD_WAVS Returns an array of all the wave files in the current directory
% and their sampling frequency.
%   LOAD_WAVS(directory) Returns an array of all the wave files in the
%   specified directory and their sampling frequency.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

% Initialize variables
data = 0;
fs = 0;

% Load the wavs
if(nargin < 1),
    D = dir;
else
    D = dir(directory);
end
for i=2:size(D,1),
    if(size(findstr(D(i).name,'.wav'),1))
        [wav,fs,nbits] = wavread(D(i).name);
        wav = wav(:,1);
        data = add_wav(wav,data);
    end
end
wavs = zeros(size(data,2)-1,size(data,1));
for i=2:size(data,2),
    wavs(i-1,:) = data(:,i)';
end