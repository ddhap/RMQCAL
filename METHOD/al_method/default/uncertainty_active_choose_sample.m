


%options_active(1)��ʾÿ��ѡ�񼸸�
%array_active��ʾ��η֣�Ϊ�ռ�ʱΪ��ȫ�Զ���
%{
load('zhuyan.mat')
m=train;
now_part_train_sample_ind1=1:100;
rest_part_train_sample_ind1=101:size(m,1);

options=[2,0,2,1];train_way=3;
options_active(1,1)=2;
train_way=3;
array_active=[];
[choose_part_serials,diff_pos]=uncertainty_active_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,train_way,options,options_active,array_active);
%}
function [choose_part_serials,diff_pos]=uncertainty_active_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,train_way,options,options_active,array_active)
%uncertainty_active_choose_sample �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%%
input_options_active_num=1;
default_options_active=1;

if length(options_active) < input_options_active_num, %����û�����options_active������input_options_active_num����ô������Ĭ��ֵ; 
  tmp = default_options_active; 
  tmp(1:length(options_active)) = options_active; 
  options_active = tmp; 
end 
%%
now_part_train_sample1=m(now_part_train_sample_ind1,:);
rest_part_train_sample1=m(rest_part_train_sample_ind1,:);
choose_size=options_active(1);
if choose_size>size(rest_part_train_sample1,1)
 errordlg('choose sample number too much');
else
array_active1=array_active;%��ȫû���ã�Ϊ��ͳһ��ʽ
[~,~,~,~,diff]=active_train(now_part_train_sample1,rest_part_train_sample1,train_way,options);
[~,diff_pos]=sort(diff,'ascend');
choose_part_serials=diff_pos(1:choose_size,1);
end



