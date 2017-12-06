%options=[];
function [net,need_type,options_out]=bayes_building(Train,options) %%Bays神经网络的分类
warning off
[xnum,ynum]=size(Train);need_type=unique(Train(:,2));

Train(:,2)=Train(:,2)+2;
Train_type=unique(Train(:,2));
Train_type1=sort(unique(Train(:,2)),'ascend');%%0,1,2,3,4

Train2num=size(Train_type1,1);%%分几类呢

for lei=1:Train2num
        suoying=1;
        for i=1:xnum
              if Train(i,2)==Train_type1(lei)
                  for k=1:ynum-2%%几个特征
                   eval(['Sample' num2str(Train_type1(lei)) '(suoying,k)' '=Train(i,k+2);']);%%每一行表示同一类不同值，每一列表示不同特征
                  end
                  suoying=suoying+1;%%最终是每一类个数
              end
        end
end


for i=1:Train2num
          TrainL=['Sample' ,num2str(Train_type1(i))];
          u{i}=mean(double(eval(TrainL)));%%i表示每一类，每一纵列表示一特征
          sigm{i}=cov(double(eval(TrainL)));
          for j=1:ynum-2%%几个特征
          sigm1{i}(j,j)=sigm{i}(j,j)+1*10^-10;
          end
end
    pw=zeros(1,Train2num);
     for lei=1:Train2num
        for i=1:xnum
              if Train(i,2)==Train_type(lei)
                 pw(lei)=pw(lei)+1;
              end
        end
    end
pwf=pw/xnum;
net.pwf=pwf;
net.sigm1=sigm1;
net.u=u;
net.feature_num=ynum-2;
net.label_num=Train2num;
options_out=options;