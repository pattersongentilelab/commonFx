% function to calculate the width of 1/2 height of a gamma function
% input
% - t is timeseries data for the gamma function
% - gamma_fx is the voltage data for the gamma function

function [bandwidth] = gamma_bandwidth(t,gamma_fx)


if max(gamma_fx)<=0
    gamma_fx = gamma_fx.*-1;
end

gamma_fx = gamma_fx./max(gamma_fx);


Tgamma50 = t(gamma_fx>=0.5);

bandwidth = Tgamma50(end) - Tgamma50(1);

end