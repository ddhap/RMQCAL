%% 清空环境变量


%% 录入输入数据
%{
载入数据并将数据分成训练和预测两类
load data.mat
a=randperm(569);
Train=data(a(1:500),:);
Test=data(a(501:end),:);
epochs=20;
%}
function [label,usetime,correct,wrong1,wrong2,TPR,FPR]=somclassify(Train,Test,classnum,epochs,zhengleishu)%%训练集，测试集，分类数一般取2
warning off

t1=clock; 
PP=Train(:,3:end);
TT=Test(:,3:end);
[P,ps] = mapminmax(PP',0,1);
 T= mapminmax('apply',TT',ps);
P=P';
T=T';
% 转置后符合神经网络的输入格式
P=P';
T=T';
% 取输入元素的最大值和最小值Q：
Q=minmax(P);

%% 网络建立和训练
% 利用newc( )命令建立竞争网络：2代表竞争层的神经元个数，也就是要分类的个数。0.1代表学习速率。
net=newc(Q,classnum,0.1);%%目标，分类数，分类速率

% 初始化网络及设定网络参数：
net=init(net);
net.trainparam.epochs=epochs;
% 训练网络：
net=train(net,P);


%% 网络的效果验证

% 将原数据回带，测试网络效果：
a=sim(net,P);
ac=vec2ind(a);

% 这里使用了变换函数vec2ind()，用于将单值向量组变换成下标向量。其调用的格式为：
%  ind=vec2ind(vec)
% 其中，
% vec：为m行n列的向量矩阵x，x中的每个列向量i，除包含一个1外，其余元素均为0。
% ind：为n个元素值为1所在的行下标值构成的一个行向量。



%% 网络作分类的预测
% 下面将后20个数据带入神经网络模型中，观察网络输出：
% sim( )来做网络仿真
Y=sim(net,T);
yc=vec2ind(Y);
ycc=yc';
%toc
yccsel=unique(ycc);
yccsel=sort(yccsel,'ascend');
yccsel_num=size(yccsel,1);
Tsel=unique(Test(:,2));
Tsel=sort(Tsel,'ascend');
Tsel_num=size(Tsel,1);
   if yccsel_num==Tsel_num%%%确认两边索引相同
      label=zeros(size(Test,1),1);
      for i=1:size(Test,1)
      label(i,1)=Tsel(find(yccsel==ycc(i,1)),1);
      end
   else
     errordlg('分类数和标准不同');
   end
t2=clock; 
usetime=etime(t2,t1);

correct=size(find((Test(:,2)-label)==0),1)/(size(Test,1));
M2=unique(Train(:,2));
M2=sort(M2,'ascend');
if size(M2,1)==2&&size(find(Test(:,2)==zhengleishu),1)~=0
    
wrong1=size(find((Test(:,2)-label)<0),1)/(size(Test,1));
wrong2=size(find((Test(:,2)-label)>0),1)/(size(Test,1));
 eval(['mistake' num2str(M2(1)) 'to',num2str(M2(2)) '=wrong1;']);
 eval(['mistake' num2str(M2(2)) 'to',num2str(M2(1)) '=wrong2;']);
           L1=find(Test(:,2)==zhengleishu);%实际=1正类
                            L2=find(label(:,1)==zhengleishu);%预测=1
                            J1=find(Test(:,2)~=zhengleishu);%实际=0
                            J2=find(label(:,1)~=zhengleishu);%预测=0
                            TP=size(intersect(L1,L2),1);
                            FN=size(intersect(L1,J2),1); 
                            FP=size(intersect(J1,L2),1); 
                            TN=size(intersect(J1,J2),1); 
                            TPR=TP/(TP+ FN);%敏感度
                            TNR=TN/(FP+TN);
                            FPR=1-TNR;%1-特异度
else
    wrong1=NaN;
    wrong2=NaN;
    TPR=NaN;
    FPR=NaN;
end