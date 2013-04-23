function plot_cepstrum(sig)
%PLOT_CEPSTRUM Plots the cepstrum of the signal.
%
% PLOT_CEPSTRUM(sig) Computes the cepstrum of sig and plots it up to 10000.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

cepstrum = abs(ifft(log(abs(fft(sig)))));
figure;
plot([1:1:10000],cepstrum(1:10000));