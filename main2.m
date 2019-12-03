clear all;
close all;
clc;


load('fcno04fz');
signal=fcno04fz;
signal=signal';
fe=8000;
RSB=5;

[signal_bruite,var] = ajout_bruit(RSB,signal);

deb = 14000;
fin = 14500;

N = fin - deb + 1;
M = floor(N/3);
L = N + 1 - M;

signal_window = signal_bruite(deb:fin);

c = signal_window(1:L);
r = signal_window(1:M);
h = hankel(c,r);

[U,S,V] = svd(h);
S2 = svds(h, M);
stem(S2)
S3 = find(S2>10000);
K = length(S3);

Uk = U(1:end,1:K);
Vk = V(1:K,1:end);
Sigmak = S(1:K,1:K);

F = diag(1 - var./(diag(Sigmak).^2));


Hmv = U*F*Sigmak*V;
sund  = [Hmv(1:end,1).' Hmv(end,2:end)];
%soundsc(sund);

%%
figure
subplot(2,2,1)
plot(signal)
title('signal original')

subplot(2,2,2)
plot(signal_bruite);
title('signal bruite')

subplot(2,2,3) 
spectrogram(signal),colorbar 
title('spectrogramme du signal original')

subplot(2,2,4) 
spectrogram(signal_bruite),colorbar 
title('spectrogramme du signal bruite')