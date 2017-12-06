%{
sample_num=5;
rank_num=3;
rank=rank_generate(sample_num,rank_num);
score_give=[1:sample_num]+100;
weight=[1,1,1];
choose_num=2;
[new_rank,choose_serial]=Borda_fusion(rank,choose_num,score_give,weight);
%}

function [new_rank,choose_serial]=Borda_fusion(rank,choose_num,score_give,weight)

if (nargin<3)
score_give=[1:size(rank,2)]+100;
weight=ones(1,size(rank,1)-1);
elseif isempty(score_give)==1
score_give=[1:size(rank,2)]+100;

elseif isempty(weight)==1
weight=ones(1,size(rank,1)-1);

end

new_rank_name=rank(1,:);
rank_tmp=rank(2:end,:);
for i=1:size(rank_tmp,1)
    for j=1:size(rank_tmp,2)
        score(i,j)=score_give(1,rank_tmp(i,j));
    end
end

new_score=weight*score;
[~,P2]=sort(new_score);
new_rank=zeros(1,size(score,2));
for i=1:size(score,2)
       new_rank(1,P2(i))=i; 
end
new_rank=[new_rank_name;new_rank];
choose_serial=new_rank_name(P2(1:choose_num));



