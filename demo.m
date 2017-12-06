%% demo

%% =================An experimental test=================
%% ======================================================

%% generate data

clc
clear


alm={'random_noneblance_choose_sample';'density_existing_choose_sample';'diveristy_existing_choose_sample';'emc_bays_choose_sample';'entropy_bays_choose_sample';'maed_learning_choose_sample';'ted_learning_choose_sample';'margin_svm_choose_sample';'margin_svmlinear_choose_sample';'margin_svmrbf_choose_sample';'multiple_view_choose_sample';'committe_learning_choose_sample';'uncertainty_bays_choose_sample';'yebatch_active_choose_sample'};
hybird={'min';'median';'mean';'geom.mean';'Bucklin';'MC1';'MC2';'MC3';'ONE';'FALL'};
name='letterUV';
name1=['D',name,'.mat'];
name2=[name,'_2.mat'];
load(name1);
TH=10;
experiment_result_type=cell(TH,1);
he=waitbar(0,'start one more experiment');
for i=1:TH
option.dimenreduction=100;
option.trainnum_per=1;
option.testnum_per=1;
option.whethersave='N';
[train,test,info_id]=initialize_database(option,data);
disp('=======Generate data finish=======');
%% generate dataflow

option_dataflow.batch_size=0;
option_dataflow.firstbatch_size=4;
option_dataflow.firstbatch_selection_strategy='random';
option_dataflow.first_choose_array=[];
option_dataflow.extra_buffersize=0;
option_dataflow.whethersave='N';

[dataflow_list,info_sd]=simulate_dataflow_list(option_dataflow,train);
disp('=======Generate dataflow finish=======');
if isempty(dataflow_list)==1
    return
end
%% active learning 

option_al.choose_num=1;
option_al.choose_strategies=[6];
option_al.fuision_strategies=0;
option_al.fuision_array=1;
train_sample=train;
test_sample=test;
option_ml.method='svm';
option_ml.parameter=[2,0,1,0.5];
option_al.end_requirement_way=5;
option_al.end_requirement_options=0.45;
result=active_learning_process(train_sample,test_sample,info_id,dataflow_list,info_sd,option_al,option_ml);
disp('=======Active learning finish=======');

%% result_analysis

label_stand=test_sample(:,2);
label_type=sort(unique(label_stand));
positive_class=label_type(1);
test_result_block=result.al_performance.test_result_block;
AUC_block=result.al_performance.AUC_block;
[confusion_table_test,accuracy1,precision1,recall1,fp1,F1measure]=result_analysis(test_result_block,label_stand,positive_class);

performance.confusion_table_test=confusion_table_test;
performance.accuracy=accuracy1;
performance.precision=precision1;
performance.recall=recall1;
performance.fp=fp1;
performance.F1measure=F1measure;
performance.AUC_block=AUC_block;
tmp.performance=performance;
tmp.result=result;
experiment_result_type{i,1}=tmp;

waitbar((i)/(TH),he,['test ',num2str(i),' experiment, total is',num2str(TH)]);
end


disp('=======result analysis finish=======');

save(name2,'experiment_result_type');