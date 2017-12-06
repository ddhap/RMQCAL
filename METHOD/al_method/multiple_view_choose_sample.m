%{
clc
clear
load('breast-cancer_data.mat')
m=data;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
options=[];
options_active(1,1)=2;
array_active=[];
[choose_part_serials,diff,diff_pos,rank,note]=multiple_view_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active,array_active);
%}

function [choose_part_serials,diff,diff_pos,rank,note]=multiple_view_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active,array_active)
%第一项为选择数目
%第二项为使用模型
%第三项为分析差异
note=0;
input_options_active_num=3;
default_options_active=[1,0,1,15];
if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
  tmp = default_options_active; 
  tmp(1:length(options_active)) = options_active; 
  options_active = tmp; 
end 

choose_size=options_active(1);
multiple_view_plan=options_active(2);
measuring_disagreement=options_active(3);
default_fea_group_num=options_active(4);

fea_num=size(m,2)-2;
if fea_num<=default_fea_group_num
default_array_active=[(1:fea_num);(1:fea_num)];
else
num_in_group=floor(fea_num/default_fea_group_num);
tmp=1:num_in_group:default_fea_group_num*num_in_group;
default_array_active=[tmp;tmp+num_in_group-1];
end

if (nargin<5) 
array_active=default_array_active;
end


if isempty(array_active)==1
   array_active=default_array_active;
elseif size(array_active,1)~=2
   array_active=default_array_active;
elseif max(max(array_active))>fea_num
   array_active=default_array_active;
elseif isempty(find((array_active(2,:)-array_active(1,:))<0))~=1
   array_active=default_array_active;
end

now_part_train_sample1=m(now_part_train_sample_ind1,:);
rest_part_train_sample1=m(rest_part_train_sample_ind1,:);


fea_group_num=size(array_active,2);

result=nan(size(rest_part_train_sample1,1),fea_group_num);
fea_tmp=now_part_train_sample1(:,3:end);
name_and_label=now_part_train_sample1(:,1:2);
for i=1:fea_group_num
       now_tmp=[name_and_label,fea_tmp(:,array_active(1,i):array_active(2,i))];
       if multiple_view_plan==0
       [net,need_type,~]=svm_building(now_tmp,[]);
       [test_result,~,~] = svm_application(rest_part_train_sample1,net,need_type);
       elseif multiple_view_plan==1
       [net,need_type,~]=bayes_building(now_tmp,[]);
       [test_result,~,~] = bays_application(rest_part_train_sample1,net,need_type);
       elseif multiple_view_plan==2   
       [net,need_type,~]=bp_building(now_tmp,[]);
       [test_result,~,~] = bp_application(rest_part_train_sample1,net,need_type);
       end
       result(:,i)=test_result;
       disp(i);
end
disagreement_level=disagreement_test(result,measuring_disagreement);

diff=disagreement_level;
[~,diff_pos]=sort(disagreement_level,'ascend');
rank=score_invert_rank(diff,'low');

choose_part_serials=diff_pos(1:choose_size,1);
  
   


    

    
    
    
    
disagreement_level=disagreement_test(result,measuring_disagreement);

diff=disagreement_level;
[~,diff_pos]=sort(disagreement_level,'ascend');
rank=score_invert_rank(diff,'low');

choose_part_serials=diff_pos(1:choose_size,1);


