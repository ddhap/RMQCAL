
%options_active(1)表示每次选择几个
%array_active表示如何分，为空集时为完全自动分
%{
load('zhuyan.mat')
m=train;
now_part_train_sample_ind1=1:100;
rest_part_train_sample_ind1=101:size(m,1);
options=[2,0,2,1];train_way=3;
options_active(1,1)=2;%选择几个样本
options_active(1,2)=1;%模型分布
options_active(1,3)=1;%熵方法
array_active=[];
[choose_part_serials,choose_pos]=entropy_active_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,train_way,options,options_active,array_active);
%}
function [choose_part_serials,choose_pos]=entropy_active_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,train_way,options,options_active,array_active)
%entropy_active_choose_sample 此处显示有关此函数的摘要
%   此处显示详细说明
%%
input_options_active_num=3;
default_options_active=[1,1,1];

if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
  tmp = default_options_active; 
  tmp(1:length(options_active)) = options_active; 
  options_active = tmp; 
end 
%%
now_part_train_sample1=m(now_part_train_sample_ind1,:);
rest_part_train_sample1=m(rest_part_train_sample_ind1,:);

choose_size=options_active(1);
stastic_model=options_active(1,2);
decide_way=options_active(1,3);
label_num=length(unique(now_part_train_sample1(:,2)));
if isempty(array_active)==1
   array_active1=[];
else
    if length(array_active)~=label_num||isempty(find(array_active<=0, 1))~=1
    array_active1=[];
    else
    array_active1=array_active;
    end
end
       
if choose_size>size(rest_part_train_sample1,1)
 errordlg('choose sample number too much');
else
    

    
array_active1=array_active;%完全没有用，为了统一格式

switch stastic_model
case 1  %bays
     [net,~,~]=bayes_building(now_part_train_sample1,[]);
     if isempty(array_active1)==1
     pwf=net.pwf;
     else
     pwf=array_active1;
     end
     
     sigm1=net.sigm1;
     u=net.u;
     feature_num=net.feature_num;
     label_num=net.label_num;
     [Lt,Wt]=size(rest_part_train_sample1);
     P_value=zeros(Lt,label_num);
     P_probability=zeros(Lt,label_num);
     if Wt~=feature_num+2%%特征数+2（标题和指针）
     msgbox('测试集特征数与训练集不同','错误','help');   
     else
      for i=1:Lt%test sample num
        for k=1:label_num%%有几个类型
        feature_value=nan(1,feature_num);
            for h=1:feature_num%%
            feature_value(1,h)=rest_part_train_sample1(i,h+2);%%特征
            end
            feature_value=double(feature_value);
            P_value(i,k)=pwf(k)*mvnpdf(feature_value,u{k},sigm1{k}); 
        end
      end
     end
     
     for i=1:Lt%test sample num
         sum_probability=sum(P_value(i,:));
         if sum_probability~=0
         P_probability(i,:)=P_value(i,:)/sum_probability;
         else
         P_probability(i,:)=[0.5,0.5];    
         end
     end
case 2
end


end

switch decide_way

case 1  %Entropy based uncertainty sampling 
    
Entropy=nan(Lt,1);
    for i=1:Lt%test sample num 
         one_label_Entropy=nan(1,label_num);
         for j=1:label_num
         P_probability_value=P_probability(i,j);    
         one_label_Entropy(1,j)= P_probability_value*log(P_probability_value+0.0000001)/log(2);
         end
         Entropy(i,1)=-1*sum(one_label_Entropy);
    end
         [value,choose_pos]=sort(Entropy,'descend');
    

        
case 2  %BvSB 
BvSB=nan(Lt,1);     

for i=1:Lt%test sample num
      P=P_probability(i,:);      
      P_max_position=find(P==max(P));
      P_max_position1=P_max_position(find(pwf(find(P==max(P)))==max(pwf(find(P==max(P))))));
      P_max_position2=P_max_position1(1);%第一的概率
      P2=P;
      P2(P_max_position2)=-inf;
      P_second_position=find(P2==max(P2));
      P_second_position1=P_second_position(find(pwf(find(P2==max(P2)))==max(pwf(find(P2==max(P2))))));
      P_second_position2=P_second_position1(1);%第二的概率
      BvSB(i,1)=P(P_max_position2)-P(P_second_position2);
end
      [value,choose_pos]=sort(BvSB,'ascend');
    
end
      choose_serial_re=choose_sample_random_from_batch(value,choose_size);
      choose_part_serials=choose_pos(choose_serial_re,1);
      

end
