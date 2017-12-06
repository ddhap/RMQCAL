clc
clear
load('3[id].mat');
load('3[id][sd].mat');

option_al.choose_num=1;
option_al.choose_strategies=[3,12,8];
option_al.fuision_strategies=8;
option_al.fuision_array=1;
train_sample=train;
test_sample=test;
option_ml.method='svm';
option_ml.parameter=[];
option_al.end_requirement_way=4;
option_al.end_requirement_options=100;
result=active_learning_process(train_sample,test_sample,info_id,dataflow_list,info_sd,option_al,option_ml);