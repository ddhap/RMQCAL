load('alg_test2.mat')
m=train;
choose_num=10;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
choose_strategies=[11,13];
fuision_strategies=2;
fuision_array=[];
[choose_part_serials,rank_result]=hybird_active_choose_sample(choose_strategies,m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num,fuision_strategies,fuision_array);

