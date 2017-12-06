%{

choose_serial=[300,400];
rank=[100,200,300,400,500;2,1,3,4,5;2,1,3,5,4];
new_rank=[100,200,300,400,500;1,2,3,4,5];

[KendallDist_choose,KendallDist_all,SpearDist_choose,SpearDist_all]=Dist_test(rank,new_rank,choose_serial);
%}
function [KendallDist_choose,KendallDist_all,SpearDist_choose,SpearDist_all]=Dist_test(rank,new_rank,choose_serial)

KendallDist_choose=0;KendallDist_all=0;
SpearDist_choose=0;SpearDist_all=0;

rank_tmp=rank(2:end,:);
choose_pos=nan(1,length(choose_serial));
for i=1:length(choose_serial)
    choose_pos(1,i)=find(rank(1,:)==choose_serial(1,i));
end
for i=1:size(rank_tmp,1)
   KendallDist_all= KendallDist_all+KendallDist(new_rank(2,:),rank_tmp(i,:));
   SpearDist_all= SpearDist_all+SpearDist(new_rank(2,:),rank_tmp(i,:));
   KendallDist_choose=KendallDist_choose+KendallDist(new_rank(2,choose_pos),rank_tmp(i,choose_pos));
   SpearDist_choose=SpearDist_choose+SpearDist(new_rank(2,choose_pos),rank_tmp(i,choose_pos));
end