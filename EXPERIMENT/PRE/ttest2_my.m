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
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
n1=number;
n2=number;
num=abs(mean1-mean2);
dem=sqrt((((n1-1)*(std1^2)+(n2-1)*(std2^2))/(n1+n2-2))*(1/n1+1/n2));
t=num/dem;
p = 2 * tcdf(-abs(t),n1+n2-2);
alpha = 0.05;
h=cast(p<= alpha, class(p));

end

%常与k-fold crossValidation（交叉验证）联用可以用于两种算法效果的比较，
%例如A1,A2两算法得出的结果分别为x，y，且从均值上看mean(x)>mean(y)，则对[h,p,ci]=ttest2(x,y);
%当h=1时，表明可以从统计上断定算法A1的结果大于（？）A2的结果（即两组数据均值的比较是有意义的）
%，h=0则表示不能根据平均值来断定两组数据的大小关系（因为区分度小）