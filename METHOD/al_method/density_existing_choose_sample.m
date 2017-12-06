%options_active(1)表示每次选择几个
%array_active表示如何分，为空集时为完全自动分
%{
clc
clear
load('alg_test2.mat')
m=train;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
options_active(1,1)=2;
[choose_part_serialss,diff,diff_pos,rank,note]=density_existing_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
%}

function [choose_part_serials,diff,diff_pos,rank,note]=density_existing_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
%uncertainty_active_choose_sample 此处显示有关此函数的摘要
%   此处显示详细说明
%% 可1次搞定
%% 适合较少的情况
%%  diff是对应rest_part_train_sample_ind1的每个值得得分 越小越好
%%  diff_pos 从高到底 将rest_part_train_sample_ind1的位置 以其分数进行排序
%%  rank     不改变原始rest part序列，对每一个给一个名次
note=1;
input_options_active_num=5;
default_options_active=[1,length(unique(m(now_part_train_sample_ind1,2))),0,1,1/(size(m,2)-2)];
if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
       tmp = default_options_active; 
       tmp(1:length(options_active)) = options_active; 
       options_active =tmp; 
end 
%%
choose_size=options_active(1);
cluster_method=options_active(2);
method=options_active(3);
c_value=options_active(4);
g_value=options_active(5);


options=[method,c_value,g_value];
rest_part_train_sample1_tmp=m(rest_part_train_sample_ind1,:);
rest_part_train_sample_fea=rest_part_train_sample1_tmp(:,3:end);
rest_part_train_sample_num=size(rest_part_train_sample_fea,1);
[u,re]=KMeans(rest_part_train_sample_fea,cluster_method);  
re_length=size(re,2);
density=nan(rest_part_train_sample_num,1);
for i=1:rest_part_train_sample_num
    type=re(i,re_length);
    pos=find(re(:,re_length)==type);
    c_num=length(pos);
    tmp=rest_part_train_sample_fea(pos,:);
    dist=0;
    for j=1:c_num
        distance=kernel_distance_calculate(rest_part_train_sample_fea(i,:),tmp(j,:),options);
        dist=dist+distance;
    end
    density(i,1)=-dist/c_num;
end

      diff=density;
    
    
    [~,diff_pos]=sort(diff,'ascend');
    rank=score_invert_rank(diff,'low');
    choose_part_serials=diff_pos(1:choose_size,1);
    







