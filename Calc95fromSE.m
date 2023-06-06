function [CI] = Calc95fromSE(predicted,se)

CI(1) = predicted;
CI(2) = predicted - (1.96*se);
CI(3) = predicted + (1.96*se);
end