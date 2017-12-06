%%用于存储数据建立


clc
clear
alm={'random_noneblance_choose_sample';'density_existing_choose_sample';'diveristy_existing_choose_sample';'emc_bays_choose_sample';'entropy_bays_choose_sample';'maed_learning_choose_sample';'ted_learning_choose_sample';'margin_svm_choose_sample';'margin_svmlinear_choose_sample';'margin_svmrbf_choose_sample';'multiple_view_choose_sample';'committe_learning_choose_sample';'uncertainty_bays_choose_sample';'yebatch_active_choose_sample'};
hybird={'RRA';'min';'median';'mean';'geom.mean';'stuart';'Borda';'reciprocal';'Bucklin';'Condorcet';'IPRAPA';'fall';'MC1';'MC2';'MC3'};



load('Dvehicle.mat');
option.dimenreduction=100;
option.trainnum_per=0.7;
option.testnum_per=0.3;
option.whethersave='Y';
[train,test,info_id]=initialize_database(option,data);
disp('=======Generate data finish=======');
%% generate dataflow

option_dataflow.batch_size=0;
option_dataflow.firstbatch_size=4;
option_dataflow.firstbatch_selection_strategy='random';
option_dataflow.first_choose_array=[];
option_dataflow.extra_buffersize=0;
option_dataflow.whethersave='Y';

[dataflow_list,info_sd]=simulate_dataflow_list(option_dataflow,train);
disp('=======Generate dataflow finish=======');
if isempty(dataflow_list)==1
    return
end