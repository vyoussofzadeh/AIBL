function [s,m,p,n_f,L] = compute_stat(idx)


L_HE  = idx(:,3) == 1;
L_MCI = idx(:,3) == 2;
L_AD  = idx(:,3) == 3;

M_HE = idx(L_HE,2);
M_MCI = idx(L_MCI,2);
M_AD = idx(L_AD,2);

% Feature normalisation
f = [M_HE;M_MCI;M_AD];

n_f = [];
for i=1:size(f,2)
    n_f(:,i) = normalize_var(f(:,i),0,1);
end

%% AD
L_HE = length(M_HE)
m(1,:)  = mean(n_f(1:L_HE,:),1);
s(1,:)  = std(n_f(1:L_HE,:),1);

% disp('=====================================================')

L_MCI = length(M_MCI)
m(2,:)  = mean(n_f(L_HE+1:L_HE+L_MCI,:),1);
s(2,:)  = std(n_f(L_HE+1:L_HE+L_MCI,:),1);

% disp('=====================================================')

L_AD = length(M_AD)
m(3,:)  = mean(n_f(end-L_AD+1:end,:),1);
s(3,:)  = std(n_f(end-L_AD+1:end,:),1);

mn = min([L_AD, L_MCI, L_HE]);

% number of data samples
L = [L_HE;L_MCI;L_AD];

k = 1;
for i=1:500
    i_HE = L_AD + L_MCI + randperm(L_HE);
    i_MCI = L_AD + randperm(L_MCI);  
    g = [n_f(1:mn),n_f(i_MCI(1:mn)),n_f(i_HE(1:mn))];
    p(i) = anova1(g,[],'off');
end
p = mean(p);
disp('=====================================================')
