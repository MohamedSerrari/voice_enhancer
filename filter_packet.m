function [packet_filtered] = filter_packet(packet, threshold, ratio)
%% Variables
% M = N*ratio (number of columns) et L = N*(1-ratio) + 1
N = length(packet);
M = floor(N * ratio);
L = N + 1 - M;

%% Constructing the hanckel matrix
c = packet(1:L);
r = packet(L:N);
h = hankel(c,r);

%% Calculating the SVD of the hanckel matrix
[U,S,V] = svd(h, 'econ');
singular_values = diag(S).';
singular_values = singular_values / max(singular_values);
stem(singular_values)

%% The number of singular values above the threshold
K = length(find(singular_values > threshold));

%% Extracting dominant singular values
simga_main_vals = diag([diag(S(1:K,1:K)).', zeros(1,M-K)]);

%% Reconstructing signal
H_filtered = U * simga_main_vals * V.';
packet_filtered = [H_filtered(1:end,1).' H_filtered(end,2:end)];

end

