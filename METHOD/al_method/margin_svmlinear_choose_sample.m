%options_active(1)��ʾÿ��ѡ�񼸸�

%{
load('alg_test2.mat')
m=train;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
options=[];
options_active(1,1)=2;
[choose_part_serialss,diff,diff_pos,rank,note]=margin_svmlinear_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
%}



function [choose_part_serials,diff,diff_pos,rank,note] = margin_svmlinear_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
%��ʶ�������� δ��ʶ�������� b

%%
note=0;
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
c_parameter=1;

model=svmtrain(now_part_train_sample1(:,2),now_part_train_sample1(:,3:end), ['-q -s 0 -c ', num2str(c_parameter)]);
[W,~]=svm_wb_caculate(model);
W = W/norm(W,2);
score = rest_part_train_sample1(:,3:end)*W;



diff=abs(score);
[~,diff_pos]=sort(diff,'ascend');
rank=score_invert_rank(diff,'low');
choose_part_serials=diff_pos(1:choose_size,1);
