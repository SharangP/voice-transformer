function [sig,fs] = load_wav(filename)
%LOAD_WAV Loads the specified wav file.
%
% LOAD_WAV(filename) Returns the mono version of the wav specified by filename
% and its sampling frequency.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

[wav,fs,nbits] = wavread(filename);
sig = wav(:,1); 