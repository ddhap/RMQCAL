%{
clc
clear
sample_num=7;
rank_num=5;
rank=rank_generate(sample_num,rank_num);
choose_num=3;
method=3;
weight=[1,1,1];
 [new_rank,choose_serial]=aggregateranks_fusion_w(rank,choose_num,method,weight);
%}
function [new_rank,choose_serial]=aggregateranks_fusion_w(rank,choose_num,method,weight)

new_rank_name=rank(1,:);
rank_tmp_tmp=rank(2:end,:);

rank_tmp=nan(size(rank_tmp_tmp,1),size(rank_tmp_tmp,2));
for i=1:size(rank_tmp_tmp,1)
    [~,p2]=sort(rank_tmp_tmp(i,:),2);
    rank_tmp(i,:)=p2;
end



sample_num=size(rank_tmp,2);
R=cell(1,size(rank_tmp,1));
for i=1:size(rank_tmp,1)
    R{1,i}=rank_tmp(i,:);
end

switch method
    case 0
    way='RRA';
    case 1
    way='min';
    case 2
    way='median';
    case 3
    way='mean';
    case 4
    way='geom.mean';
    case 5
    way= 'stuart';
end

[aggR, ~, ~] = aggregateRanks_w(R,[],way,weight);


score=aggR';
[~,P2]=sort(score);
new_rank=zeros(1,size(score,2));
for i=1:size(score,2)
       new_rank(1,P2(i))=i; 
end       
new_rank=[new_rank_name;new_rank];  
choose_serial=new_rank_name(P2(1:choose_num));

