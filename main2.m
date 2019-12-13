clear all;
close all;
clc;

%%
load('fcno04fz.mat');
signal = fcno04fz;
signal = signal';
fe     = 8000;
RSB    = 10;

noise_reduction = 5/sqrt(3); % 3;

%soundsc(signal);

%%
[signal_bruite, sigma_noise2] = ajout_bruit(RSB, signal);

%%
%soundsc(signal_bruite);

%%
packet_len = 400;
signal_filtre = filter_signal(signal_bruite, 400, sigma_noise2, noise_reduction);

%%
soundsc(signal_filtre);

%% Signal plot
% figure
% subplot(3,1,1)
% plot(signal)
% title('signal original')
% xlim([1e4, 2e4]);
% 
% subplot(3,1,2)
% plot(signal_bruite);
% title('signal bruite')
% xlim([1e4, 2e4]);
% 
% subplot(3,1,3)
% plot(signal_filtre);
% title('signal filtre')
% xlim([1e4, 2e4]);
% 
%% Spectrogramm
window = 400;
noverlap = 0.5*window;
nfft = 2.^nextpow2(window);

figure
subplot(3,1,1) 
spectrogram(signal, window, noverlap, nfft, fe, 'yaxis');
title('spectrogramme du signal original')

subplot(3,1,2) 
spectrogram(signal_bruite, window, noverlap, nfft, fe,'yaxis');
title('spectrogramme du signal bruite')

subplot(3,1,3)
spectrogram(signal_filtre, window, noverlap, nfft, fe,'yaxis');
title('spectrogramme du signal filtre')
