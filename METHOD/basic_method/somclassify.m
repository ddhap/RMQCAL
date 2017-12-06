%% ��ջ�������


%% ¼����������
%{
�������ݲ������ݷֳ�ѵ����Ԥ������
load data.mat
a=randperm(569);
Train=data(a(1:500),:);
Test=data(a(501:end),:);
epochs=20;
%}
function [label,usetime,correct,wrong1,wrong2,TPR,FPR]=somclassify(Train,Test,classnum,epochs,zhengleishu)%%ѵ���������Լ���������һ��ȡ2
warning off

t1=clock; 
PP=Train(:,3:end);
TT=Test(:,3:end);
[P,ps] = mapminmax(PP',0,1);
 T= mapminmax('apply',TT',ps);
P=P';
T=T';
% ת�ú����������������ʽ
P=P';
T=T';
% ȡ����Ԫ�ص����ֵ����СֵQ��
Q=minmax(P);

%% ���罨����ѵ��
% ����newc( )������������磺2�����������Ԫ������Ҳ����Ҫ����ĸ�����0.1����ѧϰ���ʡ�
net=newc(Q,classnum,0.1);%%Ŀ�꣬����������������

% ��ʼ�����缰�趨���������
net=init(net);
net.trainparam.epochs=epochs;
% ѵ�����磺
net=train(net,P);


%% �����Ч����֤

% ��ԭ���ݻش�����������Ч����
a=sim(net,P);
ac=vec2ind(a);

% ����ʹ���˱任����vec2ind()�����ڽ���ֵ������任���±�����������õĸ�ʽΪ��
%  ind=vec2ind(vec)
% ���У�
% vec��Ϊm��n�е���������x��x�е�ÿ��������i��������һ��1�⣬����Ԫ�ؾ�Ϊ0��
% ind��Ϊn��Ԫ��ֵΪ1���ڵ����±�ֵ���ɵ�һ����������



%% �����������Ԥ��
% ���潫��20�����ݴ���������ģ���У��۲����������
% sim( )�����������
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
   if yccsel_num==Tsel_num%%%ȷ������������ͬ
      label=zeros(size(Test,1),1);
      for i=1:size(Test,1)
      label(i,1)=Tsel(find(yccsel==ycc(i,1)),1);
      end
   else
     errordlg('�������ͱ�׼��ͬ');
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
           L1=find(Test(:,2)==zhengleishu);%ʵ��=1����
                            L2=find(label(:,1)==zhengleishu);%Ԥ��=1
                            J1=find(Test(:,2)~=zhengleishu);%ʵ��=0
                            J2=find(label(:,1)~=zhengleishu);%Ԥ��=0
                            TP=size(intersect(L1,L2),1);
                            FN=size(intersect(L1,J2),1); 
                            FP=size(intersect(J1,L2),1); 
                            TN=size(intersect(J1,J2),1); 
                            TPR=TP/(TP+ FN);%���ж�
                            TNR=TN/(FP+TN);
                            FPR=1-TNR;%1-�����
else
    wrong1=NaN;
    wrong2=NaN;
    TPR=NaN;
    FPR=NaN;
end