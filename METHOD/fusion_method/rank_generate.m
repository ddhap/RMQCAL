%{
如果是没有的排序可以将其定义为rank_num+1
clc
clear
sample_num=20;
rank_num=3;
rank=rank_generate(sample_num,rank_num);

%}
function rank=rank_generate(sample_num,rank_num)
name=zeros(1,sample_num);
for i=1:sample_num
    name(1,i)=i*2-1;
end
rank_tmp=zeros(rank_num,sample_num);
for j=1:rank_num
    rank_tmp(j,:)=randperm(sample_num);
end

rank=[name;rank_tmp];

    