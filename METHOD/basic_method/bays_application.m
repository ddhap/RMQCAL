function [test_result,diff,need_type]=bays_application(test,net,need_type)%%Bays神经网络的分类 diff越接近0越可疑
test(:,2)=test(:,2)+2;
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
label=zeros(Lt,1);
diff=zeros(Lt,1);
for i=1:Lt%test sample num
    for k=1:label_num%%有几个类型
        feature_value=nan(1,feature_num);
        for h=1:feature_num%%
        feature_value(1,h)=test(i,h+2);%%特征
        end
        feature_value=double(feature_value);
        P(k)=pwf(k)*mvnpdf(feature_value,u{k},sigm1{k}); 
    end
      P_max_position=find(P==max(P));
      P_max_position1=P_max_position(find(pwf(find(P==max(P)))==max(pwf(find(P==max(P))))));
      P_max_position2=P_max_position1(1);
      
      P2=P;
      P2(P_max_position2)=-inf;
      P_second_position=find(P2==max(P2));
      P_second_position1=P_second_position(find(pwf(find(P2==max(P2)))==max(pwf(find(P2==max(P2))))));
      P_second_position2=P_second_position1(1);

      diff(i,1)=(P(P_max_position2)-P(P_second_position2))/(P(P_max_position2)+0.00000001);
      label(i,1)=need_type(P_max_position2);
end
end

test_result=label;

%diff越大越好区分
    