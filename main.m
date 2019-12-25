 clc
close all
clear all

%%

% Input signal
noise_size = 10000;
sigma2 = 2;
mu = 0;
noise = mu + sqrt(sigma2)*randn(1,noise_size);

%% Biased and unbiased correlation estimators

[c_b, lags_b] = xcorr(noise, 'biased');
[c_unb, lags_unb] = xcorr(noise, 'unbiased');
figure;
subplot(3,1,1), plot(lags_b, c_b), title('Biased correlation estimator');
subplot(3,1,2), plot(lags_unb, c_unb), title('Unbiased correlation estimator');

[~, w] = size(c_b);
c_th = zeros(1, w);
c_th(ceil(w/2)) = sigma2;

subplot(3,1,3), plot(lags_b, c_th), title('Theoric correlation function');


%% Spectre de puissance
p = nextpow2(noise_size);
nfft = 2^p;

spectre = (abs(fftshift(fft(noise, nfft))).^2)/noise_size;

freq_axe = linspace(-.5, .5 - 1/nfft, nfft);

figure 
plot(freq_axe, spectre);
title('Spectre de puissance')

%% DSP Theorique
figure; hold on
plot(freq_axe, sigma2 * ones(1,nfft));

%% Methode de Daniell
window_size = 200;

window = ones(1, window_size)/window_size;
extended_spectre = [spectre(1,end-window_size:end) spectre spectre(1, 1:window_size)];
spectre_moyenne = conv(extended_spectre, window, 'same');
spectre_trimmed = spectre_moyenne(window_size+1:end-window_size-1) ;

plot(freq_axe, spectre_trimmed, 'r');

%% Methode de Bartlett

SegmentSize = 200;
Overlap = 0;

[periodogramme, freq_axe] = Welsh(noise, SegmentSize, Overlap);
plot(freq_axe, periodogramme, 'g');


%% Methode de Welsh

SegmentSize = 200;
Overlap = 0.5;

[periodogramme, freq_axe] = Welsh(noise, SegmentSize, Overlap);
plot(freq_axe, periodogramme, 'b');
legend('DSP Theorique','Methode de Daniell', 'Methode de Bartlett', 'Methode de Welsh');

%% Correlogramme

% [C, lags] = xcorr(noise, 'biased') ;
% % stem(lags, C);
% 
% nfft = length(lags);
% freq_axe = linspace(-.5, .5-1/nfft, nfft);
% 
% dsp = abs(fftshift(fft(C)));
% plot(freq_axe, dsp);

[partialACF,lags,bounds] = parcorr(noise,'NumAR',2);
% parcorr(noise)




