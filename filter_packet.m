function [packet_filtered] = filter_packet(packet_bruite, sigma_noise2, noise_reduction)
%% Variables
% M = N*ratio (number of columns) et L = N*(1-ratio) + 1
N = length(packet_bruite);
M = floor(N * 1/3);
L = N + 1 - M;

%% Constructing the hanckel matrix
c = packet_bruite(1:L);
r = packet_bruite(L:N);
h = hankel(c,r);

%% Calculating the SVD of the hanckel matrix
[U,S,V] = svd(h, 'econ');
sing_vals = diag(S).';

%% Reconstructing signal
threshold = noise_reduction * sqrt(M*sigma_noise2);
rank = find(sing_vals > threshold);

if isempty(rank)
    K = 0;
else
    K = rank(end);
end
% Fk = 1 - sigma_noise2./sing_vals(1:K).^2;
% simga_main_vals = diag([Fk.*sing_vals(1:K), 0.001*sing_vals(K+1:end)]);
simga_main_vals = diag([sing_vals(1:K), zeros(1,M-K)]);
H_filtered = U * simga_main_vals * V.';

packet_filtered = anti_diag_avg(H_filtered);
end

