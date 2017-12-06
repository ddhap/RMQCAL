%options_active(1)表示每次选择几个
%array_active表示如何分，为空集时为完全自动分
%{
clc
clear
load('alg_test2.mat')
m=train;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
options=[];
options_active(1,1)=2;
[choose_part_serials,diff,diff_pos,rank,note]=entropy_bays_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
%}

function [choose_part_serials,diff,diff_pos,rank,note]=entropy_bays_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
%uncertainty_active_choose_sample 此处显示有关此函数的摘要
%   此处显示详细说明
%%  diff是对应rest_part_train_sample_ind1的每个值得得分 越小越好
%%  diff_pos 从高到底 将rest_part_train_sample_ind1的位置 以其分数进行排序
%%  rank     不改变原始rest part序列，对每一个给一个名次
input_options_active_num=1;
default_options_active=1;
note=0;
if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
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
    
[net,~,~]=bayes_building(now_part_train_sample1,[]);
test=rest_part_train_sample1;

pwf=net.pwf;
sigm1=net.sigm1;
u=net.u;
feature_num=net.feature_num;
label_num=net.label_num;
P=zeros(1,label_num);
[Lt,Wt]=size(test);
if Wt~=feature_num+2%%特征数+2（标题和指针）
     msgbox('测试集特征数与训练集不同','错误','help');
     test_result=[];diff=[];need_type=[];
else
properity=nan(Lt,label_num);
entropy=nan(Lt,1);
for i=1:Lt%test sample num
    sum_tmp=0;
    for k=1:label_num%%有几个类型
        feature_value=nan(1,feature_num);
        for h=1:feature_num%%
        feature_value(1,h)=test(i,h+2);%%特征
        end
        feature_value=double(feature_value);
        P(k)=pwf(k)*mvnpdf(feature_value,u{k},sigm1{k});
        if P(k)~=0
        sum_tmp=P(k)*log(P(k))+sum_tmp;
        end
    end
       properity(i,:)=P;
       entropy(i,1)=sum_tmp;%%应该加负号但为了统一
end   
end
diff=log(entropy+min(entropy)+1);
[~,diff_pos]=sort(entropy,'ascend');
rank=score_invert_rank(diff,'low');

choose_part_serials=diff_pos(1:choose_size,1);
end
