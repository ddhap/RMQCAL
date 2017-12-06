%options_active(1)��ʾÿ��ѡ�񼸸�
%array_active��ʾ��η֣�Ϊ�ռ�ʱΪ��ȫ�Զ���
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
%uncertainty_active_choose_sample �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%%  diff�Ƕ�Ӧrest_part_train_sample_ind1��ÿ��ֵ�õ÷� ԽСԽ��
%%  diff_pos �Ӹߵ��� ��rest_part_train_sample_ind1��λ�� ���������������
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
    
[net,~,~]=bayes_building(now_part_train_sample1,[]);
test=rest_part_train_sample1;

pwf=net.pwf;
sigm1=net.sigm1;
u=net.u;
feature_num=net.feature_num;
label_num=net.label_num;
P=zeros(1,label_num);
[Lt,Wt]=size(test);
if Wt~=feature_num+2%%������+2�������ָ�룩
     msgbox('���Լ���������ѵ������ͬ','����','help');
     test_result=[];diff=[];need_type=[];
else
properity=nan(Lt,label_num);
entropy=nan(Lt,1);
for i=1:Lt%test sample num
    sum_tmp=0;
    for k=1:label_num%%�м�������
        feature_value=nan(1,feature_num);
        for h=1:feature_num%%
        feature_value(1,h)=test(i,h+2);%%����
        end
        feature_value=double(feature_value);
        P(k)=pwf(k)*mvnpdf(feature_value,u{k},sigm1{k});
        if P(k)~=0
        sum_tmp=P(k)*log(P(k))+sum_tmp;
        end
    end
       properity(i,:)=P;
       entropy(i,1)=sum_tmp;%%Ӧ�üӸ��ŵ�Ϊ��ͳһ
end   
end
diff=log(entropy+min(entropy)+1);
[~,diff_pos]=sort(entropy,'ascend');
rank=score_invert_rank(diff,'low');

choose_part_serials=diff_pos(1:choose_size,1);
end
