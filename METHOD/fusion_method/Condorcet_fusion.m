%{
sample_num=20;
rank_num=3;
rank=rank_generate(sample_num,rank_num);

weight=[3,0,1];
choose_num=2;
[new_rank,choose_serial]=Condorcet_fusion(rank,choose_num,weight);
%}

function [new_rank,choose_serial]=Condorcet_fusion(rank,choose_num,weight)  %[new_rank,choose_serial]

if (nargin<3) 
weight=[3,0,1];
elseif isempty(weight)==1
weight=[3,0,1];

end



new_rank_name=rank(1,:);
rank_tmp=rank(2:end,:);
sample_num=size(rank_tmp,2);
compare_block=cell(sample_num,sample_num);
for i=1:sample_num
    for j=1:sample_num
         compare_block{i,j}=compare_score(rank_tmp,i,j);
    end
end
score_block=zeros(sample_num,3);
for i=1:sample_num
    for j=1:sample_num
           eva=compare_block{i,j};
           if eva(1)==eva(2)
            score_block(i,3)=score_block(i,3)+1;
           elseif eva(1)>eva(2)
            score_block(i,1)=score_block(i,1)+1;   
           elseif eva(1)<eva(2)
            score_block(i,2)=score_block(i,2)+1; 
           end
    end
end
score=(score_block*weight')';
[~,P2]=sort(score,'descend');
new_rank=zeros(1,size(score,2));
for i=1:size(score,2)
       new_rank(1,i)=find(P2==i); 
end       
new_rank=[new_rank_name;new_rank];
choose_serial=new_rank_name(P2(1:choose_num));












function compare_list=compare_score(rank_tmp,P1,P2)
win=0;
lost=0;
tie=0;
for i=1:size(rank_tmp,1)
if rank_tmp(i,P1)<rank_tmp(i,P2)
    win=win+1;
elseif rank_tmp(i,P1)>rank_tmp(i,P2)
    lost=lost+1; 
elseif rank_tmp(i,P1)==rank_tmp(i,P2)
    tie=tie+1; 
end
end
compare_list=[win,lost,tie];




        
        
    