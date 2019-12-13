clc
close all
clear all

%%
load('fcno04fz');
signal = fcno04fz;
signal = signal.';
fe     = 8000;
RSB    = 5;

% axe = 1000:2000;
axe = 11000:12000;
[signal_bruite, sigma_noise2] = ajout_bruit(RSB, signal);
packet = signal_bruite(axe);

%% Variables
% M = N*ratio (number of columns) et L = N*(1-ratio) + 1
N = length(packet);
M = floor(N / 3);
L = N + 1 - M;

%% Constructing the hanckel matrix
c = packet(1:L);
r = packet(L:N);
h = hankel(c,r);

%% Calculating the SVD of the hanckel matrix
[U,S,V] = svd(h, 'econ');
singular_values = diag(S).';

% diff = (singular_values(1:end-1) - singular_values(2:end));
% diff = diff / max(diff(:));

figure
stem(singular_values)
% M
figure
% plot(conv(diff, ones(1,10)/10, 'same'))
% k = find(diff > 0.1);
% stem(k, diff(k), 'r+');
% k(end)
threshold = 4/sqrt(3) * sigma_noise2 / sqrt(M)
k = find(singular_values > threshold);
stem(k, singular_values(k), 'r+');
% k = find(singular_values > 0.4*singular_values)
% mean(diff)


%% The number of singular values above the threshold
% [~, K] = max(diff);

% K = K;

rmse = zeros(1,M);
packet_nonoise = signal(axe);

for K=1:M
    %% Extracting dominant singular values
%     simga_main_vals = diag([diag(S(1:K,1:K)).', zeros(1,M-K)]);
    simga_main_vals = diag([diag(S(1:K,1:K)).', diag(0.01*S(K+1:end,K+1:end)).']);
    

    %% Reconstructing signal
    H_filtered = U * simga_main_vals * V.';
%     packet_filtered = [H_filtered(1:end,1).' H_filtered(end,2:end)];
    packet_filtered = anti_diag_avg(H_filtered);
    rmse(K) = sqrt(sum(abs(packet_filtered - packet_nonoise).^2) / N);
end

[~, K] = min(rmse);

%% Extracting dominant singular values && Reconstructing signal
simga_main_vals = diag([diag(S(1:K,1:K)).', zeros(1,M-K)]);
H_filtered = U * simga_main_vals * V.';
packet_filtered1 = [H_filtered(1:end,1).' H_filtered(end,2:end)];
packet_filtered = anti_diag_avg(H_filtered);
%%
figure;
plot(rmse)

%%
figure
plot(packet_nonoise); hold on
plot(packet);
plot(packet_filtered);

legend('Packet original', 'Packet bruite', 'Packet filtre')

%%
soundsc(packet_filtered1);

%%
winopen()

%%
% soundsc(packet_nonoise);
[file,path] = uigetfile('*.mat');
data = struct2cell(load(strcat(path, file)));
signal = data{1}.';
% a = uiopen('*.mat')
