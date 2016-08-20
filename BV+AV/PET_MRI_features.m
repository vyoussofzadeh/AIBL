clc;clear all;close all;

load AV
load BV

% BSL
j = 1;
for i=1:length(Idx_PiB_BSL)
    L = find(Idx_PiB_BSL(i,4) == Idx_BSL(:,1));
    if isempty(L) == 0
        Idx_BSL_GMPiB(j,:) = [Idx_PiB_BSL(i,:),Idx_BSL(L,2:4)]; j = j+1;
    end
end

% 18M
j = 1;
for i=1:length(Idx_PiB_18m)
    L = find(Idx_PiB_18m(i,4) == Idx_18m(:,1));
    if isempty(L) == 0
        Idx_18m_GMPiB(j,:) = [Idx_PiB_18m(i,:),Idx_18m(L,2:4)]; j = j+1;
    end
end

% 18M
j = 1;
for i=1:length(Idx_PiB_18m)
    L = find(Idx_PiB_18m(i,4) == Idx_18m(:,1));
    if isempty(L) == 0
        Idx_18m_GMPiB(j,:) = [Idx_PiB_18m(i,:),Idx_18m(L,2:4)]; j = j+1;
    end
end

% 36M
j = 1;
for i=1:length(Idx_PiB_36m)
    L = find(Idx_PiB_36m(i,4) == Idx_36m(:,1));
    if isempty(L) == 0
        Idx_36m_GMPiB(j,:) = [Idx_PiB_36m(i,:),Idx_36m(L(1),2:4)]; j = j+1;
    end
end

% 54M
j = 1;
for i=1:length(Idx_PiB_54m)
    L = find(Idx_PiB_54m(i,4) == Idx_54m(:,1));
    if isempty(L) == 0
        Idx_54m_GMPiB(j,:) = [Idx_PiB_54m(i,:),Idx_54m(L(1),2:4)]; j = j+1;
    end
end

[s_BSL, m_BSL, p_BSL, n_f_BSL, L_BSL] = compute_stat(Idx_BSL_GMPiB);
subplot 221
barwitherr(s_BSL,m_BSL);% Plot with errorbars
set(gca,'XTickLabel',{'HC','MCI','AD'});
ylabel('Active voxels (normalised)');
title(['Baseline, p = ',num2str(p_BSL)]);
overlay_value(m_BSL,L_BSL);

[s_18M, m_18M, p_18M, n_f_18M, L_18M] = compute_stat(Idx_18m_GMPiB);
subplot 222
barwitherr(s_18M,m_18M);% Plot with errorbars
set(gca,'XTickLabel',{'HC','MCI','AD'});
ylabel('Active voxels (normalised)');
title(['18 month, p = ',num2str(p_18M)]);
overlay_value(m_18M, L_18M);

[s_36M, m_36M, p_36M, n_f_36M, L_36M] = compute_stat(Idx_36m_GMPiB);
subplot 223
barwitherr(s_36M,m_36M);% Plot with errorbars
set(gca,'XTickLabel',{'HC','MCI','AD'});
ylabel('Active voxels (normalised)');
title(['36 month, p = ',num2str(p_36M)]);
overlay_value(m_36M, L_36M);

[s_54M, m_54M, p_54M, n_f_54M, L_54M] = compute_stat(Idx_54m_GMPiB);
subplot 224
barwitherr(s_54M,m_54M);% Plot with errorbars
set(gca,'XTickLabel',{'HC','MCI','AD'});
ylabel('Active voxels (normalised)');
title(['54 month, p = ',num2str(p_54M)]);    
set(gcf, 'Position', [700   100   800   800]);
overlay_value(m_54M, L_54M);

L_PiB_all_cat = L_BSL + L_18M + L_36M + L_54M
L_PiB_all = sum(L_PiB_all_cat)

save AVBV Idx_BSL_GMPiB Idx_18m_GMPiB Idx_36m_GMPiB Idx_54m_GMPiB