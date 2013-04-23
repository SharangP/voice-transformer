function [new_wavs] = add_wav(wav,old_wavs)
%ADD_WAV Adds the sound data to the wav array.
%
% ADD_WAV(old_wavs,wav) Adds the sound data, wav, to the accumulated wavs, old_wavs.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

if(size(wav,1) > size(old_wavs,1)),
    new_wavs = zeros(size(wav,1),size(old_wavs,2)+1);
    for i=1:size(old_wavs,2),
        new_wavs(:,i) = [old_wavs(:,i); zeros(size(wav,1) - size(old_wavs,1),1)];
    end
    new_wavs(:,size(old_wavs,2)+1) = wav;
else
    new_wavs = zeros(size(old_wavs,1),size(old_wavs,2)+1);
    for i=1:size(old_wavs,2),
        new_wavs(:,i) = old_wavs(:,i);
    end
    new_wavs(:,size(old_wavs,2)+1) = [wav; zeros(size(old_wavs,1) - size(wav,1),1)];
end