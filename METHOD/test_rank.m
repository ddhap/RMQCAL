rank=[1,3,5,7,9;5,2,1,3,4;5,2,1,3,4;5,2,1,3,4];
method=2;
choose_num=1;
option_agg=[];
new_rank_block=nan(11,5);
for i=1:11
[new_rank,choose_serial]=agg_rank(i,rank,choose_num,option_agg);
new_rank_block(i,:)=new_rank(2,:);
end