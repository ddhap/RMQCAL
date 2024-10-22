
%{
sample_num=3;
rank_num=3;
rank=rank_generate(sample_num,rank_num);
choose_num=2;
[new_rank,choose_serial]=IPRAPA_fusion(rank,choose_num);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
%}
function [KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial)

KendallDist_choose=0;KendallDist_all=0;
rank_tmp=rank(2:end,:);
choose_pos=nan(1,length(choose_serial));
for i=1:length(choose_serial)
    choose_pos(1,i)=find(rank(1,:)==choose_serial(1,i));
end
for i=1:size(rank_tmp,1)
   KendallDist_all= KendallDist_all+KendallDist(new_rank(2,:),rank_tmp(i,:));
   
   KendallDist_choose=KendallDist_choose+KendallDist(new_rank(2,choose_pos),rank_tmp(i,choose_pos));
end