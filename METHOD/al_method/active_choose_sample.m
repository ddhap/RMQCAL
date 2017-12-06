%{
load('breast-cancer_data.mat')
m=data;
choose_num=2;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
query_select=1;
[choose_part_serials,diff,diff_pos,rank,AL_type]=active_choose_sample(query_select,m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num);
%}
function [choose_part_serials,diff,diff_pos,rank,AL_type]=active_choose_sample(query_select,m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num)
alm={'random_noneblance_choose_sample';'density_existing_choose_sample';'diveristy_existing_choose_sample';'emc_bays_choose_sample';'entropy_bays_choose_sample';'maed_learning_choose_sample';'ted_learning_choose_sample';'margin_svm_choose_sample';'margin_svmlinear_choose_sample';'margin_svmrbf_choose_sample';'multiple_view_choose_sample';'committe_learning_choose_sample';'uncertainty_bays_choose_sample';'yebatch_active_choose_sample';'margin_regression_choose_sample';'mv_regression_choose_sample'};
divided_group=[1,1,1,1,4,3,3,1,1,1,2,2,1,1,2,1]';
eval(['func_active=@',alm{query_select,1},';']);
[choose_part_serials,diff,diff_pos,rank,~]=select_way(func_active,m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num);
AL_type=divided_group(query_select,1);

function [choose_part_serials,diff,diff_pos,rank,note]=select_way(func_active,m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num)
    options_active(1)=choose_num;
    [choose_part_serials,diff,diff_pos,rank,note]=func_active(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);


