function [signal_filtered] = filter_signal(signal)

%% Constants
hanckel_ratio = 1/3;
overlap = 0.5;
packet_len = 200;
threshold = 0.3;

ham = hamming(packet_len).';

sig_len = length(signal);
signal_filtered = zeros(1,sig_len);
packet_num = floor(sig_len / packet_len) / (1-overlap) - 1;

dtx = 1:packet_len;
left = 1:packet_len*overlap;
right = packet_len*overlap + left - 1;

for i=0:packet_num-1
    packet = signal(i*packet_len*overlap + dtx) .* ham;
    packet_filtered = filter_packet(packet, threshold, hanckel_ratio);
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

