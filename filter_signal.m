function [signal_filtered] = filter_signal(signal_noise, packet_len, window_method, noise_reduction)

%% Constants
overlap = 0.5;

sig_len = length(signal_noise);
signal_filtered = zeros(1,sig_len);
packet_num = floor(sig_len / packet_len) / (1-overlap) - 1;

dtx = 1:packet_len;
left = 1:packet_len*(1-overlap);
right = packet_len*(1-overlap) + left;

% Calculating the noise variance based on the first packet of samples
[correlation, ~] = xcorr(signal_noise(dtx), 'unbiased');
sigma_noise2 = max(correlation);

for i=0:packet_num-1
    packet_bruite = signal_noise(i*packet_len*overlap + dtx); % .* window_method;
    packet_filtered = filter_packet(packet_bruite, sigma_noise2, noise_reduction);
    packet_reamped = packet_filtered .* window_method;
    if (i == 0)
        signal_filtered(i*packet_len*overlap + dtx) = packet_reamped.* window_method;
    elseif (i ~= packet_num-1)
        old_sig = signal_filtered((i-1)*packet_len*overlap + right);
        new_sig = packet_reamped(left).* window_method(left);
        signal_filtered(i*packet_len*overlap + left) = (old_sig + new_sig)./(window_method(left)+window_method(right));
        signal_filtered(i*packet_len*overlap + right) = packet_reamped(right).*window_method(right);
    end
end

end

