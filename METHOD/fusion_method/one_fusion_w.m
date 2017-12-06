%{
sample_num=5;
rank_num=3;
rank=rank_generate(sample_num,rank_num);
score_give=[1:sample_num]+100;
weight=[1,5,3];
choose_num=2;
[new_rank,choose_serial]=one_fusion_w(rank,choose_num,weight);
%}

function [new_rank,choose_serial]=one_fusion_w(rank,choose_num,weight)

if (nargin<3)
weight=ones(1,size(rank,1)-1);
elseif isempty(weight)==1
weight=ones(1,size(rank,1)-1);
end

new_rank_name=rank(1,:);
rank_tmp=rank(2:end,:);
pos=find(weight==max(weight));
new_rank=rank_tmp(pos(1),:);
[~,P2]=sort(new_rank);
new_rank=[new_rank_name;new_rank];
choose_serial=new_rank_name(P2(1:choose_num));
