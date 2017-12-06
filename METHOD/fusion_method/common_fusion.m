%{
sample_num=20;
rank_num=3;
rank=rank_generate(sample_num,rank_num);
which_is_first=[1,2,3];
choose_num=8;
method=1;
[new_rank,choose_serial]=common_fusion(rank,which_is_first,method,choose_num);
%}

function [new_rank,choose_serial]=common_fusion(rank,which_is_first,method,choose_num)
appendix=((which_is_first-1)*0.05)';
new_rank_name=rank(1,:);
rank_tmp=rank(2:end,:);
for i=1:size(rank_tmp,1)
    rank_tmp(i,:)=rank_tmp(i,:)+appendix(i,1);
end
switch method
    case 1
new_score=min(rank_tmp);
    case 2
new_score=max(rank_tmp);
    case 3
new_score=sum(rank_tmp);
end

[~,P2]=sort(new_score);
new_rank=zeros(1,size(rank_tmp,2));
for i=1:size(rank_tmp,2)
       new_rank(1,P2(i))=i; 
end
new_rank=[new_rank_name;new_rank];
choose_serial=new_rank_name(P2(1:choose_num));