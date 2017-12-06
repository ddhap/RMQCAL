

%options_active(2)表示分几组group
%options_active(1)表示每次选择几个
%array_active表示如何分，为空集时为完全自动分
%{
load('zhuyan.mat')
m=train;
now_part_train_sample_ind1=1:100;
rest_part_train_sample_ind1=101:size(m,1);


options=[2,0,2,1];train_way=3;
options_active(1,1)=2;
options_active(1,2)=3;
array_active=[[1,1,1,1,1,1,1,1,1,1],[1,1,1,1,1,1,1,1,1,1]*2,[1,1,1,1,1,1,1,1,1,1]*3];
[choose_part_serials,serial_all]=comb_active_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,train_way,options,options_active,array_active);
%}
function [choose_part_serials,serial_all]=comb_active_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,train_way,options,options_active,array_active)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

%%
input_options_active_num=2;
default_options_active=[1,3];

if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
  tmp = default_options_active; 
  tmp(1:length(options_active)) = options_active; 
  options_active = tmp; 
end 
divided_group=array_active;
if isempty(array_active)==1
feature_num=size(m,2)-2;
group=options_active(2);
divided_group_f = comb_feature_divided_serial(feature_num,group,divided_group);
elseif length(unique(array_active))~=options_active(2)
feature_num=size(m,2)-2;
group=options_active(2);
divided_group_f = comb_feature_divided_serial(feature_num,group,divided_group);
else
feature_num=size(m,2)-2;
divided_group_f=array_active; 
end
    
%%
now_part_train_sample1=m(now_part_train_sample_ind1,:);
rest_part_train_sample1=m(rest_part_train_sample_ind1,:);


group=options_active(2);
choose_size=options_active(1);
%divided_group_f=comb_feature_divided_serial(feature_num,group,divided_group);
%%
%建立comb分类器组
divided_need_train=cell(1,group);
divided_need_test=cell(1,group);
net=cell(1,group);
net_info=cell(1,group);
rest_part_train_sample1_num=size(rest_part_train_sample1,1);
test_result=zeros(rest_part_train_sample1_num,group);
%%
%train process
for i=1:group
    divided_need_train{1,i}=[now_part_train_sample1(:,1:2),now_part_train_sample1(:,find(divided_group_f==i)+2)];
    divided_need_test{1,i}=[rest_part_train_sample1(:,1:2),rest_part_train_sample1(:,find(divided_group_f==i)+2)];
    [net{1,i},net_info{1,i},~,test_result(:,i),~]=active_train(divided_need_train{1,i},divided_need_test{1,i},train_way,options); 
end
analysis_test_result=zeros(size(test_result,1),2);    
for j=1:size(test_result,1)   
analysis_test_result(j,1)=j;
analysis_test_result(j,2)=length(unique(test_result(j,:)));
end
[value,serial]=sort(analysis_test_result(:,2),'descend');
 could_choose_num=length(find(value==max(value)));
 diff=sort(unique(value),'descend');
 serial_all=[];
for k=1:length(unique(value))
    serial_part=serial(find(value==diff(k,1)),1);
    serial_now=serial_part(randperm(length(find(value==diff(k,1)))));
    serial_all=[serial_all;serial_now];
end
choose_part_serials=serial_all(1:choose_size,1);
    
