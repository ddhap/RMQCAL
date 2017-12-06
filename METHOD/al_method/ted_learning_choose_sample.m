%{
clc
clear
load('alg_test2.mat')
m=train;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
options_active(1,1)=2;

[choose_part_serials,diff,diff_pos,rank,note]=ted_learning_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);

%}

function [choose_part_serials,diff,diff_pos,rank,note]=ted_learning_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
%% 可1次搞定
%第一位是 选择的样本数量
%第二位是选择核函数0为高斯核
%第三位是核函数参数t
%第四位是maed参数 =100是maed =0是TED
note=1;
input_options_active_num=4;
default_options_active=[1,0,0.5,0];


if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
       tmp = default_options_active; 
       tmp(1:length(options_active)) = options_active; 
       options_active =tmp; 
end 

options = [];
choose_size=options_active(1);
kernel_type=options_active(2);
options.t=options_active(3);
options.ReguBeta=options_active(4);

if kernel_type==0
options.KernelType = 'Gaussian';
end

[diff_pos_tmp,VAL_tmp] = MAED(m(:,3:end),size(m,1),options);
%diff_pos %表示每个样本n 从高到低的名次 第一行表示排名第一的样本序号 前几个就是应该选出的点

%VAL_tmp 是他们的值
diff_pos1=diff_pos_tmp;VAL1=VAL_tmp;
for i=1:length(diff_pos_tmp)
    if isempty(find(now_part_train_sample_ind1==diff_pos_tmp(i,1)))==0
       diff_pos1(i,1)=0;
    end
end

diff_pos=diff_pos1(diff_pos1~=0,1);
VAL=-VAL1(diff_pos1~=0,1);

diff=nan(size(diff_pos,1),1);
for i=1:size(diff_pos,1)
    diff(i,1)=VAL(find(diff_pos==rest_part_train_sample_ind1(i)));
end

rank=score_invert_rank(diff,'low');
[P1,diff_tmp_tmp]=sort(diff,'ascend');
choose_part_serials=diff_tmp_tmp(1:choose_size,1);