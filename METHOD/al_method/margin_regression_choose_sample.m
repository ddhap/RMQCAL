
%{
load('regression_tmpuse.mat')
m=train(:,1:50);
aa=20;
now_part_train_sample_ind1=[1:1+aa,47:47+aa,412:412+aa,1335:1335+aa];
rest_part_train_sample_ind1=setdiff((1:1805),now_part_train_sample_ind1);
options=[];
options_active(1,1)=2;
[choose_part_serialss,diff,diff_pos,rank,note]=margin_regression_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);

%}




function [choose_part_serials,diff,diff_pos,rank,note] = margin_regression_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
%标识样本索引 未标识样本索引 b

%%
note=0;
input_options_active_num=1;
default_options_active=1;


if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
  tmp = default_options_active; 
  tmp(1:length(options_active)) = options_active; 
  options_active = tmp; 
end 

%%
now_part_train_sample1=m(now_part_train_sample_ind1,:);
rest_part_train_sample1=m(rest_part_train_sample_ind1,:);
choose_size=options_active(1);

model=ordinalregression_train(now_part_train_sample1(:,3:end),now_part_train_sample1(:,2));





[margin_te,~,~]=ordinalregression_test(rest_part_train_sample1(:,3:end),rest_part_train_sample1(:,2),model);
score=margin_te;
diff=score;
[~,diff_pos]=sort(diff,'ascend');
rank=score_invert_rank(diff,'low');
choose_part_serials=diff_pos(1:choose_size,1);





