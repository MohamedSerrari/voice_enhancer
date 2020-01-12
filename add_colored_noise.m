function [signal_bruite, var] = add_colored_noise(RSB,signal,color)

%% Making sure input signal is a line
signal = signal(:).';
N  = length(signal);

%% Generating noise
cn = dsp.ColoredNoise('Color', color, 'SamplesPerFrame', N);
noise = cn().';

%% Calculating the energy of both signals
Ps = signal * signal.';
Pb = noise * noise.';

Ps = Ps/N; 
Pb = Pb/N;

%% Adding noise
var = (Ps/Pb)*10^(-RSB/10);
noise = sqrt(var) * noise;
signal_bruite = signal + noise;

end

