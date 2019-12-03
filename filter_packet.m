function [packet_filtered, rmse] = filter_packet(packet_bruite, packet_original, ratio)
%% Variables
% M = N*ratio (number of columns) et L = N*(1-ratio) + 1
N = length(packet_bruite);
M = floor(N * ratio);
L = N + 1 - M;

%% Constructing the hanckel matrix
c = packet_bruite(1:L);
r = packet_bruite(L:N);
h = hankel(c,r);

%% Calculating the SVD of the hanckel matrix
[U,S,V] = svd(h, 'econ');
sing_vals = diag(S).';

rmse = zeros(M,1);

%% Calculating rmse for all values of K
for K=1:M
    % Extracting dominant singular values
    simga_main_vals = diag([sing_vals(1:K), zeros(1,M-K)]);

    % Reconstructing signal
    H_filtered = U * simga_main_vals * V.';
    packet_filtered = [H_filtered(1:end,1).' H_filtered(end,2:end)];
    
    % root mean square error
    rmse(K) = sqrt(sum(abs(packet_filtered - packet_original).^2) / N);
end

%% Reconstructing signal

% diff = abs(rmse(1:end-1) - rmse(2:end));
% diff = diff/max(diff);
% improve = find(diff > 0.99);
% K = improve(end);

[~, K] = min(rmse);

if K < 5
    K = 0;
end

% K = 12;

simga_main_vals = diag([diag(S(1:K,1:K)).', zeros(1,M-K)]);
H_filtered = U * simga_main_vals * V.';
packet_filtered = [H_filtered(1:end,1).' H_filtered(end,2:end)];

end

