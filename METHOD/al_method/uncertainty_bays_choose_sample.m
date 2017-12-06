%options_active(1)��ʾÿ��ѡ�񼸸�

%{
load('alg_test2.mat')
m=train;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
options=[];
options_active(1,1)=2;
[choose_part_serialss,diff,diff_pos,rank,note]=uncertainty_bays_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
%}

function [choose_part_serials,diff,diff_pos,rank,note]=uncertainty_bays_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
%uncertainty_active_choose_sample �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%%  diff�Ƕ�Ӧrest_part_train_sample_ind1��ÿ��ֵ�õ÷� ԽСԽ��
%%  diff_pos ��λ�Ӹߵ���  rest_part_train_sample_ind1��λ��
%%  rank     ���ı�ԭʼrest part���У���ÿһ����һ������

input_options_active_num=1;
default_options_active=1;
note=0;
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
    
[net,need_type,~]=bayes_building(now_part_train_sample1,[]);
[~,diff,~]=bays_application(rest_part_train_sample1,net,need_type);
%class_type='bays';
[~,diff_pos]=sort(diff,'ascend');
rank=score_invert_rank(diff,'low');
choose_part_serials=diff_pos(1:choose_size,1);
end
