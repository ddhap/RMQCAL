%options=[];
function [net,need_type,options_out]=bayes_building(Train,options) %%Bays������ķ���
warning off
[xnum,ynum]=size(Train);need_type=unique(Train(:,2));

Train(:,2)=Train(:,2)+2;
Train_type=unique(Train(:,2));
Train_type1=sort(unique(Train(:,2)),'ascend');%%0,1,2,3,4

Train2num=size(Train_type1,1);%%�ּ�����

for lei=1:Train2num
        suoying=1;
        for i=1:xnum
              if Train(i,2)==Train_type1(lei)
                  for k=1:ynum-2%%��������
                   eval(['Sample' num2str(Train_type1(lei)) '(suoying,k)' '=Train(i,k+2);']);%%ÿһ�б�ʾͬһ�಻ֵͬ��ÿһ�б�ʾ��ͬ����
                  end
                  suoying=suoying+1;%%������ÿһ�����
              end
        end
end


for i=1:Train2num
          TrainL=['Sample' ,num2str(Train_type1(i))];
          u{i}=mean(double(eval(TrainL)));%%i��ʾÿһ�࣬ÿһ���б�ʾһ����
          sigm{i}=cov(double(eval(TrainL)));
          for j=1:ynum-2%%��������
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