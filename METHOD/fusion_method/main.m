clc
clear
sample_num=20;
rank_num=5;
rank=rank_generate(sample_num,rank_num);
choose_num=5;

RECORD=[];
[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,0);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];

[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,1);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];

[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,2);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];

[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,3);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];

[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,4);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];

[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,5);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];

[new_rank,choose_serial]=IPRAPA_fusion(rank,choose_num);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];

score_give=[1:sample_num]+100;
[new_rank,choose_serial]=Borda_fusion(rank,choose_num,score_give,[2,2,2,2,2]);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];

[new_rank,choose_serial]=Bucklin_fusion(rank,choose_num);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];

[new_rank,choose_serial]=Condorcet_fusion(rank,choose_num,[3,0,1]);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];

[new_rank,choose_serial]=reciprocal_fusion(rank,choose_num);
[KendallDist_choose,KendallDist_all]=KendallDist_test(rank,new_rank,choose_serial);
RECORD=[RECORD,[KendallDist_choose;KendallDist_all]];
