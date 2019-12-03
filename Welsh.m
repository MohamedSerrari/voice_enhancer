function [dsp_avg, freq_axe] = Welsh(Data, SegmentSize, Overlap)

OverlapPoints = floor(SegmentSize * Overlap);

% Segmenting data
y = buffer(Data, SegmentSize, OverlapPoints, 'nodelay');
[~, w] = size(y);

% FFT of segments
dsp = abs(fftshift(fft(y, SegmentSize).')).^2 / SegmentSize;
dsp_avg = sum(dsp, 1)/w;
freq_axe = linspace(-.5 , .5 - 1/SegmentSize, SegmentSize);
end