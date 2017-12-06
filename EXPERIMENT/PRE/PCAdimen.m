%{
http://zhidao.baidu.com/question/375494153.html
�������ݲ������ݷֳ�ѵ����Ԥ������
load data.mat
a=randperm(569);
Train=data(a(1:500),:);
Test=data(a(501:end),:);
per=100;
%}


%%
%{
input
Trainѵ����
Test ���Լ�
per  ���Ȱٷֱ�
output
PA_rebuilt �Ľ�ѵ����
PB_rebuilt �Ľ����Լ�
ycsjy_num  BP��Ԫ����
%}
%%
function[PA_rebuilt,PB_rebuilt,ycsjy_num]=PCAdimen(Train,Test,per)

tezheng_num=size(Train,2);
%%---��һ��
train1=Train(:,3:end);
test1=Test(:,3:end);

[train_re,ps] = mapminmax(train1',0,1);
 test_re= mapminmax('apply',test1',ps);
train_re=train_re';
test_re=test_re';
Train=[Train(:,1:2),train_re];
Test=[Test(:,1:2),test_re];
PA=[train_re];
PB=[test_re];
%%---��һ������
[a1,b1,c1,d1]=princomp(PA);%c1����֤���
%%[a0,b0,c0]=pcacov(cov(PTrain))
%%[a2,b2,c2]= pcacov(cov(PTest))
%%[a3,b3,c3,d3]=princomp(PTest);%%
percent_explained=100*c1/sum(c1);%��c0��ͬ
zhucengfeng_NUM=0;%%���ɷָ�������ͨ������������ɼ������ɷ�
for i = 1:tezheng_num-2
if sum(percent_explained(1:i))<per
zhucengfeng_NUM=i;
end
end
if per~=100
    zhucengfeng_NUM=zhucengfeng_NUM+1;
end



P0=b1(:,1:zhucengfeng_NUM);%%ѡ����������
ycsjy_num=(fix((sqrt(zhucengfeng_NUM))/10)+1)*10;%%������Ԫ����
PA_mean=mean(PA);
%%for i=1:4 xmean(i,:)=PA(i,:)-PA_mean;end;xmean*a1=b1��ԭ����
PA_rebuilt=[Train(:,1:2),P0];%%��ѵ����

PB_num=size(PB,1);
if PB_num==0
PB_rebuilt=[];  
else 
for i=1:PB_num 
    xmean_PB(i,:)=PB(i,:)-PA_mean;
end
    b2=xmean_PB*a1;
    P1=b2(:,1:zhucengfeng_NUM);
    PB_rebuilt=[Test(:,1:2),P1];%%��ѵ����
end

if per==100
  PA_rebuilt=Train;
  PB_rebuilt=Test;
end