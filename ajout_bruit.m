function [signal_bruite,var] = ajout_bruit(RSB,signal)

signal = signal(:).';
N = length(signal);
noise = randn(1,N);

%% Calcul de l'energie des deux signaux
Ps = signal * signal.';
Pb = noise * noise.';

Ps = Ps/N; 
Pb = Pb/N;

%% Ajout du bruit
var = (Ps/Pb)*10^(-RSB/10);
bruit = sqrt(var)*noise;
signal_bruite = signal + bruit;
end

