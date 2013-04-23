function [chunks] = sig_chunks(sig,number)
%SIG_CHUNKS Breaks a signal into chunks.
%
% SIG_CHUNKS(sig,number) Windows sig into number parts and returns
% the signal chunks.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

width = floor(length(sig)/number);
window = rectwin(width);
for i = 1:number,
    smallchunk = sig((i-1)*width+1:i*width);
    x = smallchunk .* window;
    chunks(i,:) = x';
end