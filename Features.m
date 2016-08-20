clc;close all;clear all;

load features

idx_AD  = idx_AD_cor;
idx_MCI = idx_MCI_cor;
idx_HC  = idx_HC_cor;

%% Data correction for missing values
[L_AD,idx_AD_cor]  = f_correction(idx_AD);
[L_MCI,idx_MCI_cor] = f_correction(idx_MCI);
[L_HC,idx_HC_cor]  = f_correction(idx_HC);

disp('=====================================================')

% Feature normalisation
f = [idx_AD_cor;idx_MCI_cor;idx_HC_cor];

n_f = [];
for i=1:size(f,2)
    n_f(:,i) = normalize_var(f(:,i),0,1);
end

%% AD
L_AD = length(idx_AD);
m(3,:)  = mean(n_f(1:L_AD,:),1);
s(3,:)  = std(n_f(1:L_AD,:),1);
% mn_AD = min(idx_AD_cor,1);
% mx_Ad = max(idx_AD_cor,1);


disp('=====================================================')

L_MCI = length(idx_MCI);
m(2,:)  = mean(n_f(L_AD+1:L_AD+L_MCI,:),1);
s(2,:)  = std(n_f(L_AD+1:L_AD+L_MCI,:),1);



disp('=====================================================')

L_HC = length(idx_HC);
m(1,:)  = mean(n_f(end-L_HC+1:end,:),1);
s(1,:)  = std(n_f(end-L_HC+1:end,:),1)/sqrt(length(s));


%% ploting featutes


l1 = [3,6,8:38];
ym = m(:,l1);
ys = s(:,l1);
% figure,
% h = barwitherr(ys,ym);% Plot with errorbars
% set(gca,'XTickLabel',{'HC','MCI','AD'});
leg = {'Age','CDR','MMSE','Immediate Recall','Delayed Recall',...
    'AXT117','BAT126','HMT3','HMT7','HMT13','HMT40','HMT100',...
    'HMT102','RCT6','RCT11','RCT20','RCT392',...
    'APOEGen1','APOEGen2',...
    'MHPSYCH','MH2NEURL','MH4CARD','MH6HEPAT','MH8MUSCL','MH9ENDO',...
    'MH10GAST','MH12RENA','MH16SMOK','MH17MALI',...
    'GM','WM','CSF','PiB'};
% legend(leg);
% ylabel('Y Value')
% set(h(1),'FaceColor','k');

%% Anova test

k = 1;
for j=l1
    for i=1:500
        i_HC = L_AD + L_MCI + randperm(L_HC);
        i_MCI = L_AD + randperm(L_MCI);
        g = [n_f(1:L_AD,j),n_f(i_MCI(1:L_AD),j),n_f(i_HC(1:L_AD),j)];
        p(k,i) = anova1(g,[],'off');
    end
    k = k+1;
end
p = mean(p,2);
[pidx,l2] = sort(p);
l3 = find(p(l2)<=5e-2);
pidx

figure,
h = barwitherr(ys(:,l2),ym(:,l2));% Plot with errorbars
set(gca,'XTickLabel',{'HC','MCI','AD'});
lgnd = legend(leg(:,l2),'location','eastoutside','Fontsize',8,'Box','off');
% columnlegend(2, leg(:,l2))
ylabel('Y Value');
set(h(1),'FaceColor','k');
title('All features');
box off
set(gca, 'Color', 'None')
set(lgnd,'color','none');
legend boxoff
set(gcf, 'Position', [100   200   1000   700]);


figure,
h = barwitherr(ys(:,l2(l3)),ym(:,l2(l3)));% Plot with errorbars
set(gca,'XTickLabel',{'HC','MCI','AD'});
ll = cell(1,length(l3),1);
for i=1:length(l3)
    ll{1,i} = [leg{:,l2(i)},' (p =',num2str(pidx(i)),')'];
end
lgnd = legend(ll,'location','eastoutside','Fontsize',10,'Box','off'); 
ylabel('Y Value');
set(h(1),'FaceColor','k');
title('Significant features')
box off
set(gca, 'Color', 'None')
set(lgnd,'color','none');
legend boxoff
set(gcf, 'Position', [400   200   800   400]);

f = f(:,l1);
f_sig    = f(:,l2(l3));
f_sig_AD = f(1:L_AD,l2(l3));
f_sig_MCI = f(L_AD+1:L_AD+L_MCI,l2(l3));
f_sig_HC = f(L_AD+L_MCI+1:end,l2(l3));
f_sig_HC_170 = f_sig_HC(1:170,:);

n_f = n_f(:,l1);
fn_sig    = n_f(:,l2(l3));
fn_sig_AD = n_f(1:L_AD,l2(l3));
fn_sig_MCI = n_f(L_AD+1:L_AD+L_MCI,l2(l3));
fn_sig_HC = n_f(L_AD+L_MCI+1:end,l2(l3));
fn_sig_HC_170 = fn_sig_HC(1:170,:);

labels = leg(:,l2(l3));