load('test_rank.mat');
object=[1;2;4;5;6;7;9;13];
rank_old=rank_result(object,:);
hybird={'RRA';'min';'median';'mean';'geom.mean';'stuart';'Borda';'reciprocal';'Bucklin';'Condorcet';'IPRAPA';'fall';'MC1';'MC2';'MC3'};
fusion_method=[2,3,4,5,9,13,14,15];
choose_num=2;
option_agg=[];
block=nan(4,length(fusion_method));
new_rank_list=nan(length(fusion_method),size(rank_old,2));

[new_rank,choose_serial]=agg_rank(fusion_method(method),rank_old,choose_num,option_agg);


for method=1:length(fusion_method)
[new_rank,choose_serial]=agg_rank(fusion_method(method),rank_old,choose_num,option_agg);
new_rank_list(method,:)=new_rank(2,:);
[block(1,method),block(2,method),block(3,method),block(4,method)]=Dist_test(rank_old,new_rank(),choose_serial);
end









