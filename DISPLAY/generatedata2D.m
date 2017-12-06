%{
clc
clear
mu1 = [2 3];
SIGMA1 = [1 0; 0 2];
num=50;
mu2 = [6 7];
SIGMA2 = [1 0; 0 2];
[train_sample,label]=generatedata2D(mu1,mu2,SIGMA1,SIGMA2,num);
%}
function [train_sample,label]=generatedata2D(mu1,mu2,SIGMA1,SIGMA2,num)
r1 = mvnrnd(mu1,SIGMA1,num);
r2 = mvnrnd(mu2,SIGMA2,num);
train_sample=[r1;r2];
label=[ones(num,1);zeros(num,1)];

First_list=randperm(num*2);
while(length(unique(label(First_list(1:2))))==1)
    First_list=randperm(num*2);
end
train_sample=train_sample(First_list,:);
label=label(First_list,:);
