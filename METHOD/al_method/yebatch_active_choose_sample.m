%{
clc
clear
load('alg_test2.mat')
m=train;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];


options=[2,0,1,1];
options_active(1,1)=2;
options_active(1,2)=0.0377;
array_active=[];
[choose_part_serials,diff,diff_pos,rank,note]=yebatch_active_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
%}


function [choose_part_serials,diff,diff_pos,rank,note]=yebatch_active_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
beta1 = 0.01; % SVM reg parameter, to be tuned
beta2 = 1;    % model parameter, to be tuned
rho = 1;      % fixed
thres = 1e-12;% to be tuned 
note=0;
%%
input_options_active_num=2;
default_options_active=[1,0.0377];

if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
    tmp = default_options_active; 
    tmp(1:length(options_active)) = options_active; 
    options_active = tmp; 
end 


%%


label=now_part_train_sample_ind1';
unlabel=rest_part_train_sample_ind1';
b=options_active(1,1);
sigma=options_active(1,2);
gnd=m(:,2);
fea=m(:,3:end);
K=rbfkernel(fea,fea,sigma);


ln = length(label);
un = length(unlabel);
n = ln + un;
yl = gnd(label);

seq = randperm(length(unlabel));
batch = unlabel(seq(1:b));
clear dex; 
    
K0 = K(label',label);
K1 = K(unlabel',unlabel)/2;
kv = (n-ln-b)*sum(K(unlabel',label),2)/n -  2*(ln+b)*sum(K1,2)/n;
r0 = ones(ln,1);

    for iter1 = 1:500
    %%%%%% outer loop %%%%%%  
    % r-subproblem (ADMM)
    z0 = zeros(b,1);
    lambda0 = zeros(b,1);
    for iter2 = 1:500
        T1 = inv( K0^2+beta1*K0+rho*K(label',batch)*K(label',batch)'/2 + 1e-4*eye(ln));
        T2 = K0*yl+K(batch',label)'*(rho*z0+lambda0)/2;
        r = T1*T2;
        v = ( rho*K(batch',label)*r-lambda0 )/(rho+2);
        ind = find(abs(v) > 2/(rho+2));
        z = zeros(b,1);
        z(ind) = (abs(v(ind))-2/(rho+2)).*sign(v(ind));
        clear v;
        clear ind;
        
        dif = z-K(batch',label)*r;
        lambda = lambda0+rho*dif;
        
        if sum(dif.^2)/b <= thres
            break;
        else
            z0 = z;
            lambda0 = lambda;
        end
    end
    clear T1;
    clear T2;
    clear z0;
    clear z;
    clear lambda0;
    clear lambda;
    clear dif;
  %  [t,iter1,iter2]
    
    % alpha-subproblem (QP)
    a = abs(K(unlabel',label)*r);
    a = (a.^2+2*a)/beta2;
    opts = optimset('Algorithm','interior-point-convex');
    alpha = quadprog(2*K1,kv+a,[],[],ones(1,n-ln),b,zeros(n-ln,1),[],[],opts);
    diff=alpha*-1;
    [~,diff_pos] = sort(diff,'ascend');
    batch = unlabel(diff_pos(1:b)');
    error = sum((r-r0).^2)/ln;
    if error <= thres
        break;
    else
        r0 = r;
    end
    %%%%%% outer loop %%%%%%      
    end
    clear K0;
    clear K1;
    clear kv;
    clear a;    
    rank=score_invert_rank(diff,'low');
    choose_part_serials=diff_pos(1:b);
end