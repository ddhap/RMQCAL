%{
clc
clear
load('alg_test2.mat')
m=train;
now_part_train_sample_ind1=[125:225];
rest_part_train_sample_ind1=[(1:124),(226:350)];
options_active(1,1)=2;

[choose_part_serials,diff,diff_pos,rank,note]=maed_learning_choose_sample1(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);

%}

function [choose_part_serials,diff,diff_pos,rank,note]=maed_learning_choose_sample1(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
%% 可1次搞定
%第一位是 选择的样本数量
%第二位是选择核函数0为高斯核
%第三位是核函数参数t
%第四位是maed参数 =100是maed =0是TED
note=1;
input_options_active_num=4;
default_options_active=[1,0,0.5,100];


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

rest_part_train_sample1_tmp=m(rest_part_train_sample_ind1,:);
rest_part_train_sample_fea=rest_part_train_sample1_tmp(:,3:end);

[diff_pos,VAL]=MAED(rest_part_train_sample_fea,size(rest_part_train_sample_fea,1),options);
diff=nan(size(rest_part_train_sample_fea,1),1);
for i=1:size(rest_part_train_sample_fea,1)
    diff(diff_pos(i),1)=-VAL(i);

end
rank=score_invert_rank(diff,'low');
[choose_part_serials,~] = MAED(rest_part_train_sample_fea,choose_size,options);


