function [signal_filtered, rmse_evolution] = filter_signal(signal_bruite, signal_original)

%% Constants
hanckel_ratio = 1/3;
overlap = 0.5;
packet_len = 200;

ham = hamming(packet_len).';

sig_len = length(signal_bruite);
signal_filtered = zeros(1,sig_len);
packet_num = floor(sig_len / packet_len) / (1-overlap) - 1;

dtx = 1:packet_len;
left = 1:packet_len*overlap;
right = packet_len*overlap + left;

rmse_evolution = [];

for i=0:packet_num-1
    packet_bruite = signal_bruite(i*packet_len*overlap + dtx) .* ham;
    packet_original = signal_original(i*packet_len*overlap + dtx) .* ham;
    [packet_filtered, ev] = filter_packet(packet_bruite, packet_original, hanckel_ratio);
    rmse_evolution = [rmse_evolution, ev];
    packet_reamped = packet_filtered ./ ham;
    if (i == 0)
        signal_filtered(i*packet_len*overlap + dtx) = packet_reamped;
    elseif (i ~= packet_num-1)
        old_sig = signal_filtered((i-1)*packet_len*overlap + right);
        new_sig = packet_reamped(left);
        signal_filtered(i*packet_len*overlap + left) = (old_sig + new_sig)/2;
        signal_filtered(i*packet_len*overlap + right) = packet_reamped(right);
    end
end

end

