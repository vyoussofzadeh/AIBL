% Date: 21 Aug 2016
% Vahab Youssofzadeh
% -------------------
clc,clear,close all
%% loading scans
% files = spm_select(Inf,'image','Select image files');
% save f_FDG_all files
load f_FDG_all

%% Extracting features from all FDG scans
% for i=1:size(files,1)
%     f1 = files(i,:);
%     HeaderInfo = spm_vol(f1);
%     img = spm_read_vols(HeaderInfo);
%     img(isnan(img)) = 0; % use ~isfinite instead of isnan to replace +/-inf with zero
%     M(i,:) = mean(mean(mean(img)));
% end
% save M_FDG M
load M_FDG

[T_all, T_all_label, raw1] = xlsread('PET_F18_12_15_2015.csv');
[T_dxcon, T_dxcon_label, raw2] = xlsread('aibl_pdxconv_28-Apr-2015.csv');

disp('BSL = 1');
disp('m18  = 2');
disp('m36 = 3');
disp('m54 = 4');
in = input ('Enter time interval?');

if in == 1
    ti = 'bl';
elseif in == 2
    ti = 'm18';
elseif in == 3
    ti = 'm36';
 elseif in == 4
    ti = 'm54';   
end

Idx = [];
k = 1;
for i=1:size(files,1)
    f1 = files(i,:);
    f2 = strfind(f1,'.nii');
    f3 = str2double(f1(f2-6:f2-1));
    f4 = find(T_all(:,1) == f3);
    f5 = find(T_dxcon(:,1) == T_all(f4,2));
    f6 = find(strcmp(T_dxcon_label(f5,3),ti));
    if isempty(f6) == 0
        if length(f6)> 1
            f7 = f5(f6(2));
        else
            f7 = f5(f6(1));
        end
        Idx(k,:) = [f3, T_dxcon(f7,[1,4]),M(i)];
        idx_int(k,:) = T_dxcon_label(f7,3);
        k = k+1;
    end
end

[s, m, p, n_f, L]  = compute_stat(Idx);
figure,
h = barwitherr(s,m); % Plot with errorbars
overlay_value(m,L);
set(gca,'XTickLabel',{'HC','MCI','AD'});
ylabel('Active voxels (normalised)');
title([ti, 'p = ',num2str(p)]);

