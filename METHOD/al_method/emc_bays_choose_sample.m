%options_active(1)��ʾÿ��ѡ�񼸸�

%{
load('alg_test2.mat')
m=train;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
options=[];
options_active(1,1)=2;
[choose_part_serialss,diff,diff_pos,rank,note]=emc_bays_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
%}



function [choose_part_serials,diff,diff_pos,rank,note] = emc_bays_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
%��ʶ�������� δ��ʶ�������� b

%%
note=0;
input_options_active_num=1;
default_options_active=1;
%��һλ��ѡ����Ŀ
%�ڶ�λ�ǲ���ģ��   


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
label_type=sort(unique(m(:,2)));    
[net,~,~]=bayes_building(now_part_train_sample1,[]);
[net1,need_type1,~]=svm_building(now_part_train_sample1,[]);

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
else
Expected_Model_Change=nan(Lt,1);
for i=1:Lt%test sample num
    sum_tmp=0;
    for k=1:label_num%%�м�������
        feature_value=nan(1,feature_num);
        for h=1:feature_num%%
        feature_value(1,h)=test(i,h+2);%%����
        end
        feature_value=double(feature_value);
        P(k)=pwf(k)*mvnpdf(feature_value,u{k},sigm1{k})+0.0001; 
        if P(k)==inf
           P(k)=99999;
        end
        tmp=[0,label_type(k),feature_value];
        tmp_train_sample1=[now_part_train_sample1;tmp];
        [net_new,need_type2,~]=svm_building(tmp_train_sample1,[]);
        [test_result1,~,~] = svm_application(m,net1,need_type1);
        [test_result2,~,~] = svm_application(m,net_new,need_type2);
         result_diff=zeros(length(test_result1),1);
         for j=1:length(test_result1)
             if test_result1(j,1)~=test_result2(j,1)
                result_diff(j,1)=1;
             end
         end
         emc_diff=sum(result_diff);
         sum_tmp=P(k)*emc_diff+sum_tmp;
    end
       %properity(i,:)=P;
       Expected_Model_Change(i,1)=sum_tmp;%%Ӧ�üӸ��ŵ�Ϊ��ͳһ
end   
end
 
    
    diff=-(Expected_Model_Change);
    
    
    [~,diff_pos]=sort(diff,'ascend');
    rank=score_invert_rank(diff,'low');
    choose_part_serials=diff_pos(1:choose_size,1);
end 
    
    
