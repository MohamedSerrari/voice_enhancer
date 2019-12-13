clear all;
close all;
clc;

%%
load('fcno04fz.mat');
signal = fcno04fz;
signal = signal';
fe     = 8000;
RSB    = 10;

noise_reduction = 3;

% soundsc(signal);

%%
[signal_bruite, sigma_noise2] = ajout_bruit(RSB, signal);

%%
% soundsc(signal_bruite);

%%
signal_filtre = filter_signal(signal_bruite, sigma_noise2, noise_reduction);

%%
soundsc(signal_filtre);

%%
% [w, h] = size(rmse_evolution);
% [X, Y] = meshgrid(1:w, 1:h);
% % imagesc(evolution.')
% figure
% plot(rmse_evolution(1:end, 75))
% figure
% surf(X, Y, rmse_evolution.');
% shading interp

%%
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
% figure
% subplot(3,1,1) 
% spectrogram(signal),colorbar 
% title('spectrogramme du signal original')
% 
% subplot(3,1,2) 
% spectrogram(signal_bruite),colorbar 
% title('spectrogramme du signal bruite')
% 
% subplot(3,1,3)
% spectrogram(signal_filtre),colorbar
% title('spectrogramme du signal filtre')

% soundsc(signal_filtre);
% % soundsc(signal_bruite);

%%
% deb = 14000;
% fin = 16000;
% 
% N = fin - deb + 1;
% M = floor(N/3);
% L = N + 1 - M;
% 
% w = hamming(N).';
% signal_window = signal_bruite(deb:fin) .* w;
% 
% c = signal_window(1:L);
% r = signal_window(L:N);
% h = hankel(c,r);
% 
% [U,S,V] = svd(h, 'econ');
% S2 = svds(h, M);
% S2 = S2/max(S2);
% stem(S2);
% 
% K = length(find(S2 > 0.1));
% 
% %%
% SimgaMainVals = diag([diag(S(1:K,1:K)).', zeros(1,M-K)]);
% 
% H_filtered = U * SimgaMainVals * V.';
% sund  = [H_filtered(1:end,1).' H_filtered(end,2:end)];
% voice_reamped = sund ./ w;
% 
% % Uk = U(1:K,1:K);
% % Vk = V(1:K,1:K);
% % Sigmak = S(1:K,1:K);
% 
% % F = diag(1 - sigma_noise2./(diag(Sigmak).^2));
% 
% 
% % Hmv = Uk * F * Sigmak * Vk;
% % sund  = [Hmv(1:end,1).' Hmv(end,2:end)];
% soundsc(voice_reamped);

%%
% figure
% subplot(2,2,1)
% plot(signal)
% title('signal original')
% 
% subplot(2,2,2)
% plot(signal_bruite);
% title('signal bruite')
% 
% subplot(2,2,3) 
% spectrogram(signal),colorbar 
% title('spectrogramme du signal original')
% 
% subplot(2,2,4) 
% spectrogram(signal_bruite),colorbar 
% title('spectrogramme du signal bruite')