function [sig1,sig2,split_loc] = split_sig(sig)
%SPLIT_SIG Splits the signal in half
%
% SPLIT_SIG(sig) Splits sig in half, returning the halves sig1 and sig2, 
% and the location of the split in the original signal, split_loc
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

split_loc = ceil(length(sig)/2);
sig1 = sig(1:split_loc);
sig2 = sig(split_loc+1:length(sig));