%{
load examgrades;
x=grades(:,1);
y=grades(:,2);

mean1=mean(x);
mean2=mean(y);
std1=std(x);
std2=std(y);
number=size(x,1);
[p1,h1] = ttest2_my(mean1,mean2,std1,std2,number);
[h,p,ci,stats]=ttest2(x,y);

%}



function [p,h] = ttest2_my(mean1,mean2,std1,std2,number)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n1=number;
n2=number;
num=abs(mean1-mean2);
dem=sqrt((((n1-1)*(std1^2)+(n2-1)*(std2^2))/(n1+n2-2))*(1/n1+1/n2));
t=num/dem;
p = 2 * tcdf(-abs(t),n1+n2-2);
alpha = 0.05;
h=cast(p<= alpha, class(p));

end

%����k-fold crossValidation��������֤�����ÿ������������㷨Ч���ıȽϣ�
%����A1,A2���㷨�ó��Ľ���ֱ�Ϊx��y���ҴӾ�ֵ�Ͽ�mean(x)>mean(y)�����[h,p,ci]=ttest2(x,y);
%��h=1ʱ���������Դ�ͳ���϶϶��㷨A1�Ľ�����ڣ�����A2�Ľ�������������ݾ�ֵ�ıȽ���������ģ�
%��h=0���ʾ���ܸ���ƽ��ֵ���϶��������ݵĴ�С��ϵ����Ϊ���ֶ�С��