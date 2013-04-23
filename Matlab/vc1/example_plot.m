function plot_example()
%PLOT_EXAMPLE Plots example cepstrums.
%
% PLOT_EXAMPLE loads vowel sounds of two subjects (male and female),
% calculates their cepstrums, and plots the cepstrums on the same axes.
%
% By: Matthew Hutchinson
% Created: 12/09/04
% Rice University
% Elec 301 Project

% Load the wavs
ah_b = load_wav('wavs/aaa_b.wav');
ah_g = load_wav('wavs/aaa_g.wav');
ee_b = load_wav('wavs/eee_b.wav');
ee_g = load_wav('wavs/eee_g.wav');

% Compute cepstrums
ah_b_cep = abs(ifft(log(abs(fft(ah_b)))));
ah_g_cep = abs(ifft(log(abs(fft(ah_g)))));
ee_b_cep = abs(ifft(log(abs(fft(ee_b)))));
ee_g_cep = abs(ifft(log(abs(fft(ee_b)))));

% Plot the cepstrums
cep_length = 5000;
y_max = 0.03;
figure;
subplot(221);
plot([1:1:cep_length],ah_b_cep(1:cep_length));
axis([0 cep_length 0 y_max]);
title('Subject A (Male)');
ylabel('ah','Rotation',0);
subplot(222);
plot([1:1:cep_length],ah_g_cep(1:cep_length));
axis([0 cep_length 0 y_max]);
title('Subject B (Female)');
subplot(223);
plot([1:1:cep_length],ee_b_cep(1:cep_length));
axis([0 cep_length 0 y_max]);
ylabel('ee','Rotation',0);
subplot(224);
plot([1:1:cep_length],ee_g_cep(1:cep_length));
axis([0 cep_length 0 y_max]);