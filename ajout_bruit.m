function [signal_bruite,var] = ajout_bruit(RSB,signal)


N=length(signal);
random=randn(1,N);


Ps =0;
Pb =0;
for i=1:N
    Ps=Ps+(signal(i))^2;
    Pb=Pb+(random(i))^2;
end

Ps = Ps/N; 
Pb= Pb/N;

var = (Ps/Pb)*10^(-RSB/10);
%var = 1;
bruit = sqrt(var)*random;
signal_bruite= signal +bruit;


end

