
function [tbl] = mnrfit_tbl(B,stats,VarNames)

nVar = size(VarNames,1);

tbl = table('Size',[nVar 1],'VariableTypes','double','VariableNames',{'estimate'},'RowNames',VarNames);

y = 1:length(B);
y = y(length(B)-nVar:end);

for x = 1:nVar
    
    predicted = B(y(x));
    se = stats.se(y(x));
    tbl.estimate = predicted;
    tbl.low95(x) = predicted - (1.96*se);
    tbl.hi95(x) = predicted + (1.96*se);
    tbl.p_val(x) = stats.p(y(x));
end