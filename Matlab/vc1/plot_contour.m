function plot_contour(sig,fs)
%PLOT_CONTOUR Plots the signal, its absolute value, and its contour.
%
% PLOT_CONTOUR(sig) Computes the absolute value of sig and the smoothed
% absolute value of sig. It then plots all three.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

abs_sig = abs(sig);
abs_sig_smoothed = smooth(abs_sig,2000);

Ts = 1/fs;

figure;

subplot(311);
plot([Ts:Ts:Ts*length(sig)],sig);
title('Signal');
subplot(312);
plot([Ts:Ts:Ts*length(abs_sig)],abs_sig);
title('Signal Magnitude');
subplot(313);
plot([Ts:Ts:Ts*length(abs_sig_smoothed)],abs_sig_smoothed);
hold on;
plot([Ts:Ts:Ts*length(abs_sig_smoothed)],0.03,'r');
hold off;
title('Signal Contour');
xlabel('time (s)');