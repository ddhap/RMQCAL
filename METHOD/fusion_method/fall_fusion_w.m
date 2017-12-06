%{
clc
clear
sample_num=15;
rank_num=3;
rank=rank_generate(sample_num,rank_num);
weight=[1;0.5;2];
choose_num=2;
[new_rank,choose_serial]=fall_fusion_w(rank,choose_num,weight);
%}


function [new_rank,choose_serial]=fall_fusion_w(rank,choose_num,weight)
default_choose_block=nan(size(rank,1)-1,1);
for i=1:size(rank,1)-1    
default_choose_block(i,1)=choose_num+i-1;
end
rank_num=size(rank,1)-1;

if (nargin<3) 
weight_tmp=default_choose_block;
elseif isempty(weight)==1||rank_num~=length(weight)
weight_tmp=default_choose_block;
else
weight_tmp=weight;    
end
sample_num=size(rank,2);
rank_num=size(rank,1)-1;
weight_tmp_min=min(weight_tmp);
weight=choose_num/weight_tmp_min*weight_tmp;

weight(weight>sample_num)=sample_num;

[c1,c2]=sort(weight,'descend');
rest=rank;
rank_result=ones(1,sample_num)*(choose_num+1);

for i=1:rank_num
    rank_tmp=rest(2:end,:);
    stand=rank_tmp(c2(i),:);
    [~,p2]=sort(stand,'ascend');
    rest=rest(:,p2(1:c1(i)));
end
choose_serial=rest(1,:);
for i=1:length(choose_serial)
    rank_result(1,find(rank(1,:)==choose_serial(i)))=1;
end
new_rank=[rank(1,:);rank_result];
