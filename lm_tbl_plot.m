
function tbl = lm_tbl_plot(mdl)

VarNames = mdl.CoefficientNames';
nVar = size(VarNames,1);

tbl = table('Size',[nVar 4],'VariableTypes',{'double','double','double','double'},'VariableNames',{'estimate','low95','hi95','p_val'},'RowNames',VarNames);

for x = 1:nVar 
    CI95 = Calc95fromSE(table2array(mdl.Coefficients(x,1)),table2array(mdl.Coefficients(x,2)));
    tbl.estimate(x) = CI95(1);
    tbl.low95(x) = CI95(2);
    tbl.hi95(x) = CI95(3);
    tbl.p_val(x) = table2array(mdl.Coefficients(x,4));
end

% plot
varNum = 1:1:height(tbl);
tbl = flipud(tbl);

figure
hold on
errorbar(tbl.estimate(1:end-1),varNum(1:end-1),[],[],abs(diff([tbl.estimate(1:end-1) tbl.low95(1:end-1)],[],2)),abs(diff([tbl.estimate(1:end-1) tbl.hi95(1:end-1)],[],2)),'ok','MarkerFaceColor','k')
plot([0 0],[varNum(1) varNum(end)],'--k')
title('Model')
ax = gca; ax.Box = 'on'; ax.YTick = varNum(1:end-1); ax.YTickLabels = tbl_95CI.Name(1:end-1); ax.YLim = [0 length(varNum)+1]; ax.XLim = [-20 20]; ax.XTick = -50:10:50;

end