
% Calculate estimate with 95% Confidence Intervals for a linear mixed effects model
function [tblFixed,tblRand] = lme_tbl_plot(mdl)

[betaFixed,varNamesFixed,statsFixed] = fixedEffects(mdl);
VarNamesFixed = table2array(varNamesFixed);
nVarFixed = size(VarNamesFixed,1);

statsFixed2 = dataset2cell(statsFixed);
tblFixed = table('Size',[nVarFixed 4],'VariableTypes',{'double','double','double','double'},'VariableNames',{'estimate','low95','hi95','p_val'},'RowNames',VarNamesFixed);
tblFixed.estimate = betaFixed;
tblFixed.low95 = cell2mat(statsFixed2(2:end,7));
tblFixed.hi95 = cell2mat(statsFixed2(2:end,8));
tblFixed.p_val = cell2mat(statsFixed2(2:end,6));


[betaRand,varNamesRand,statsRand] = randomEffects(mdl);
VarNamesRand = table2array(varNamesRand);
nVarRand = size(VarNamesRand,1);

statsRand2 = dataset2cell(statsRand);
tblRand = table('Size',[nVarRand 6],'VariableTypes',{'cell','cell','double','double','double','double'},'VariableNames',{'group','level','estimate','low95','hi95','p_val'});
tblRand.group = statsRand2(2:end,1);
tblRand.level = statsRand2(2:end,2);
tblRand.estimate = betaRand;
tblRand.low95 = cell2mat(statsRand2(2:end,9));
tblRand.hi95 = cell2mat(statsRand2(2:end,10));
tblRand.p_val = cell2mat(statsRand2(2:end,8));

% plot
varNumFixed = 1:1:height(tblFixed);
tblFixed = flipud(tblFixed);
varNumRand = 1:1:height(tblRand);
tblRand = flipud(tblRand);

figure
subplot(1,2,1)
hold on
errorbar(tblFixed.estimate(1:end-1),varNumFixed(1:end-1),[],[],abs(diff([tblFixed.estimate(1:end-1) tblFixed.low95(1:end-1)],[],2)),abs(diff([tblFixed.estimate(1:end-1) tblFixed.hi95(1:end-1)],[],2)),'ok','MarkerFaceColor','k')
plot([0 0],[varNumFixed(1) varNumFixed(end)],'--k')
title('Fixed Effects')
ax = gca; ax.Box = 'on'; ax.YTick = varNumFixed(1:end-1); ax.YTickLabels = flipud(VarNamesFixed(2:end)); ax.YLim = [0 length(varNumFixed)+1]; ax.XLim = [min(tblFixed.low95)*1.1 max(tblFixed.hi95)*1.1];

subplot(1,2,2)
hold on
errorbar(tblRand.estimate,varNumRand,[],[],abs(diff([tblRand.estimate tblRand.low95],[],2)),abs(diff([tblRand.estimate tblRand.hi95],[],2)),'ok','MarkerFaceColor','k')
plot([0 0],[varNumRand(1)-1 varNumRand(end)+1],'--k')
title('Random Effects')
ax = gca; ax.Box = 'on'; ax.YTick = varNumRand(1:end); ax.YTickLabels = tblRand.level; ax.YLim = [0 length(varNumRand)+1]; ax.XLim = [min(tblRand.low95)*1.1 max(tblRand.hi95)*1.1];

end