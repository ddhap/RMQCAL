%ycsjy_num=50
%lr=0.1;
%epochs=1000;
%goal=0.1;
%options=[50,0.1,1000,0.1];
function [net,need_type,options_out]=bp_building(Train,options) %%BP神经网络的分类
if isempty(options)==1
   options=[50,0.1,1000,0.1];
end
ycsjy_num=options(1);
lr=options(2);
epochs=options(3);
goal=options(4);

if size(Train,2)<3||ycsjy_num<1||epochs<1||goal<0||fix(ycsjy_num)~=ycsjy_num||lr<=0||fix(epochs)~=epochs
errordlg('input parameter wrong');
net=[];
need_type=[];
else
warning off
P_train=Train(:,3:end)';%%特征
Tc_train=Train(:,2)';%%类型
%T_train=ind2vec(Tc_train);%%化一维为二维
scsjy_num=1;
net=feedforwardnet(ycsjy_num,'trainlm');%%ycsjy_num个隐层神经元，1个输出神经元
%net=newff(minmax(P_train),[ycsjy_num scsjy_num],{'tansig','purelin'},'trainlm');%%ycsjy_num个隐层神经元，1个输出神经元
%tranferFcn属性 'logsig' 隐层采用Sigmoid传输函数
%tranferFcn属性 'logsig' 输出层采用Sigmoid传输函数
%trainFcn属性 'traingdx' 自适应调整学习速率附加动量因子梯度下降反向传播算法训练函数

%% 设置网络参数
net.trainParam.epochs=epochs;%%允许最大训练步数1000步

net.trainParam.show=10;%每间隔100步显示一次训练结果
net.trainParam.lr=lr;%学习速率0.1
net.trainParam.showWindow = false;
net.trainParam.showCommandLine = false; 
net.trainParam.goal=goal;%训练目标最小误差0.1

%% 训练网络
net=train(net,P_train,Tc_train);
need_type=sort(unique(Train(:,2)));
end
options_out=options;