
%{
sample_num=20;
rank_num=3;
rank=rank_generate(sample_num,rank_num);
score_give=[1:sample_num]+100;
weight=[1,0,1];
choose_num=2;
[new_rank,choose_serial]=reciprocal_fusion(rank,score_give,weight,choose_num);
%}

function [new_rank,choose_serial]=reciprocal_fusion(rank,choose_num)
new_rank_name=rank(1,:);
rank_tmp=rank(2:end,:);
score=zeros(1,size(rank_tmp,2));
for j=1:size(rank_tmp,2)
    sum_value=0;
    for i=1:size(rank_tmp,1)
        sum_value=sum_value+1/rank_tmp(i,j);
    end
    score(1,j)=1/sum_value;
end
[~,P2]=sort(score);
new_rank=zeros(1,size(score,2));
for i=1:size(score,2)
       new_rank(1,P2(i))=i; 
end       
new_rank=[new_rank_name;new_rank];
choose_serial=new_rank_name(P2(1:choose_num));

        
        
    
