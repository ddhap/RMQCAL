
%{
clc;clear;
load('regression_tmpuse.mat')
m=train;
aa=20;
now_part_train_sample_ind1=[1:1+aa,47:47+aa,412:412+aa,1335:1335+aa];
rest_part_train_sample_ind1=setdiff((1:1805),now_part_train_sample_ind1);
options=[];
options_active(1,1)=2;
options_active(1,2)=5;%分组数
options_active(1,3)=30;%每组特征数

[choose_part_serialss,diff,diff_pos,rank,note]=mv_regression_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
%}

function [choose_part_serials,diff,diff_pos,rank,note] = mv_regression_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
%标识样本索引 未标识样本索引 b

%%
note=0;
fea_num=size(m,2)-2;
sample_num=size(m,1);
group_num_tmp=ceil(sqrt(fea_num));
input_options_active_num=3;
default_options_active=[1,group_num_tmp,floor(fea_num/group_num_tmp)];


if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
  tmp = default_options_active; 
  tmp(1:length(options_active)) = options_active; 
  options_active = tmp; 
end 

%%
choose_size=options_active(1);
group_size=options_active(2);
group_fea_size=options_active(3);
dec_te_block=nan(length(rest_part_train_sample_ind1),group_size);
score=nan(length(rest_part_train_sample_ind1),1);
for i=1:group_size
    serial=randperm(fea_num);
    use_fea=serial(1:group_fea_size)+2;
    n=m(:,[1:2,use_fea]);
    now_part_train_sample1=n(now_part_train_sample_ind1,:);
    rest_part_train_sample1=n(rest_part_train_sample_ind1,:);
    model=ordinalregression_train(now_part_train_sample1(:,3:end),now_part_train_sample1(:,2));
    [~,dec_te,~]=ordinalregression_test(rest_part_train_sample1(:,3:end),rest_part_train_sample1(:,2),model);
    dec_te_block(:,i)=dec_te;
end
for ii=1:length(rest_part_train_sample_ind1)
    score(ii,1)=var(dec_te_block(ii,:));
end

diff=-score;

[~,diff_pos]=sort(diff,'ascend');
rank=score_invert_rank(diff,'low');
choose_part_serials=diff_pos(1:choose_size,1);


end