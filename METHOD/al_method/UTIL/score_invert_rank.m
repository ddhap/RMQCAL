%{
score=[200,100,300,300,100,100,400,800,500]';
best_sample='high';
rank=score_invert_rank(score,best_sample);
%}
function rank=score_invert_rank(score,best_sample)

score_unique=unique(score);

if strcmp(best_sample,'high')==1 %分数越高越好
   score_unique_sort=sort(score_unique,'descend');
elseif strcmp(best_sample,'low')==1 %分数越低越好
   score_unique_sort=sort(score_unique,'ascend'); 
end
rank=nan(size(score,1),1);
score_num=nan(size(score_unique_sort,1),1);
start_rank=score_num;

for i=1:size(score_unique_sort,1)
   score_num(i,1)=length(find(score==score_unique_sort(i,1)));
end

score_num_tmp=[0;score_num];
for i=1:size(score_unique_sort,1)
start_rank(i,1)=sum(score_num_tmp(1:i,1))+1;
end

for i=1:size(score,1)
   rank(i,1)=start_rank(find(score_unique_sort==score(i,1)));
end