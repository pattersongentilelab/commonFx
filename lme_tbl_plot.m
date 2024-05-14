
% Calculate estimate with 95% Confidence Intervals for a linear mixed effects model
function [tblFixed,tblGrp] = lme_tbl_plot(mdl,varargin)

q = inputParser;
q.addParameter('isBinary',0,@islogical); % ==1 if outcome is binary
q.addParameter('plotFixed',1,@islogical); % plot fixed effects
q.addParameter('plotRand',0,@islogical); % plot random effects

q.parse(varargin{:});


[betaFixed,varNamesFixed,statsFixed] = fixedEffects(mdl);
VarNamesFixed = table2array(varNamesFixed);
nVarFixed = size(VarNamesFixed,1);

statsFixed2 = dataset2cell(statsFixed);
tblFixed = table('Size',[nVarFixed 4],'VariableTypes',{'double','double','double','double'},'VariableNames',{'estimate','low95','hi95','p_val'},'RowNames',VarNamesFixed);

[betaGrp,varNamesGrp,statsGrp] = randomEffects(mdl);
VarNamesGrp = table2array(varNamesGrp);
nVarGrp = size(VarNamesGrp,1);

statsGrp2 = dataset2cell(statsGrp);
tblGrp = table('Size',[nVarGrp 6],'VariableTypes',{'cell','cell','double','double','double','double'},'VariableNames',{'group','level','estimate','low95','hi95','p_val'});
tblGrp.group = statsGrp2(2:end,1);
tblGrp.level = statsGrp2(2:end,2);
    
if q.Results.isBinary==1
    tblFixed.estimate = exp(betaFixed);
    tblFixed.low95 = exp(cell2mat(statsFixed2(2:end,7)));
    tblFixed.hi95 = exp(cell2mat(statsFixed2(2:end,8)));
    tblGrp.estimate = exp(betaGrp);
    tblGrp.low95 = exp(cell2mat(statsGrp2(2:end,9)));
    tblGrp.hi95 = exp(cell2mat(statsGrp2(2:end,10)));
else
    tblFixed.estimate = betaFixed;
    tblFixed.low95 = cell2mat(statsFixed2(2:end,7));
    tblFixed.hi95 = cell2mat(statsFixed2(2:end,8));
    tblFixed.p_val = cell2mat(statsFixed2(2:end,6));
    tblGrp.estimate = betaGrp;
    tblGrp.low95 = cell2mat(statsGrp2(2:end,9));
    tblGrp.hi95 = cell2mat(statsGrp2(2:end,10));
end
tblFixed.p_val = cell2mat(statsFixed2(2:end,6));
tblGrp.p_val = cell2mat(statsGrp2(2:end,8));

% plot
varNumFixed = 1:1:height(tblFixed);
tblFixed = flipud(tblFixed);
varNumGrp = 1:1:height(tblGrp);
tblGrp = flipud(tblGrp);

figure
if q.Results.plotFixed==1
subplot(1,2,1)
hold on
errorbar(tblFixed.estimate(1:end-1),varNumFixed(1:end-1),[],[],abs(diff([tblFixed.estimate(1:end-1) tblFixed.low95(1:end-1)],[],2)),abs(diff([tblFixed.estimate(1:end-1) tblFixed.hi95(1:end-1)],[],2)),'ok','MarkerFaceColor','k')
if q.Results.isBinary==1
    plot([1 1],[varNumFixed(1) varNumFixed(end)],'--k')
else
    plot([0 0],[varNumFixed(1) varNumFixed(end)],'--k')
end

title('Fixed Effects')
ax = gca; ax.Box = 'on'; ax.YTick = varNumFixed(1:end-1); ax.YTickLabels = flipud(VarNamesFixed(2:end)); ax.YLim = [0 length(varNumFixed)+1]; ax.XLim = [min(tblFixed.low95)*1.1 max(tblFixed.hi95)*1.1];
end

if q.Results.plotRand==1
    subplot(1,2,2)
    hold on
    errorbar(tblGrp.estimate,varNumGrp,[],[],abs(diff([tblGrp.estimate tblGrp.low95],[],2)),abs(diff([tblGrp.estimate tblGrp.hi95],[],2)),'ok','MarkerFaceColor','k')
    if q.Results.isBinary==1
        plot([1 1],[varNumFixed(1) varNumFixed(end)],'--k')
    else
        plot([0 0],[varNumFixed(1) varNumFixed(end)],'--k')
    end
    title('Group Effects')
    ax = gca; ax.Box = 'on'; ax.YTick = varNumGrp(1:end); ax.YTickLabels = tblGrp.level; ax.YLim = [0 length(varNumGrp)+1]; ax.XLim = [min(tblGrp.low95)*1.1 max(tblGrp.hi95)*1.1];
end
end