%ycsjy_num=50
%lr=0.1;
%epochs=1000;
%goal=0.1;
%options=[50,0.1,1000,0.1];
function [net,need_type,options_out]=bp_building(Train,options) %%BP������ķ���
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
P_train=Train(:,3:end)';%%����
Tc_train=Train(:,2)';%%����
%T_train=ind2vec(Tc_train);%%��һάΪ��ά
scsjy_num=1;
net=feedforwardnet(ycsjy_num,'trainlm');%%ycsjy_num��������Ԫ��1�������Ԫ
%net=newff(minmax(P_train),[ycsjy_num scsjy_num],{'tansig','purelin'},'trainlm');%%ycsjy_num��������Ԫ��1�������Ԫ
%tranferFcn���� 'logsig' �������Sigmoid���亯��
%tranferFcn���� 'logsig' ��������Sigmoid���亯��
%trainFcn���� 'traingdx' ����Ӧ����ѧϰ���ʸ��Ӷ��������ݶ��½����򴫲��㷨ѵ������

%% �����������
net.trainParam.epochs=epochs;%%�������ѵ������1000��

net.trainParam.show=10;%ÿ���100����ʾһ��ѵ�����
net.trainParam.lr=lr;%ѧϰ����0.1
net.trainParam.showWindow = false;
net.trainParam.showCommandLine = false; 
net.trainParam.goal=goal;%ѵ��Ŀ����С���0.1

%% ѵ������
net=train(net,P_train,Tc_train);
need_type=sort(unique(Train(:,2)));
end
options_out=options;