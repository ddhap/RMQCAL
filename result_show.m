function experiment_result_performance=result_show(experiment_result_type,serials,th)
color={'b','g','r','c','m','y','k','b','g','r','c','m','y','k','b','g','r','c','m','y','k'};
alm={'random_noneblance_choose_sample';'density_existing_choose_sample';'diveristy_existing_choose_sample';'emc_bays_choose_sample';'entropy_bays_choose_sample';'maed_learning_choose_sample';'ted_learning_choose_sample';'margin_svm_choose_sample';'margin_svmlinear_choose_sample';'margin_svmrbf_choose_sample';'multiple_view_choose_sample';'committe_learning_choose_sample';'uncertainty_bays_choose_sample';'yebatch_active_choose_sample'};
hybird={'min';'median';'mean';'geom.mean';'Bucklin';'MC1';'MC2';'MC3'};

default_serials=1:size(experiment_result_type,1);
if nargin==1
serials=default_serials;
th=0;
end
exp_r=experiment_result_type(serials,1);
num=nan(size(exp_r,1),1);
for i=1:size(exp_r,1)
num(i,1)=size(exp_r{i, 1}.performance.accuracy,2);
end


if size(unique(num))~=1
    errordlg('they are not from same dataflow');
    experiment_result_performance=[];
    return
end
test_num=sum(sum(exp_r{1, 1}.performance.confusion_table_test));




experiment_result_performance.auc=smooth_line(exp_r{1, 1}.performance.AUC_block,th,test_num);
experiment_result_performance.accuracy=smooth_line(exp_r{1, 1}.performance.accuracy,th,test_num);
experiment_result_performance.precision=smooth_line(exp_r{1, 1}.performance.precision,th,test_num);
experiment_result_performance.recall=smooth_line(exp_r{1, 1}.performance.recall,th,test_num);
experiment_result_performance.fp=smooth_line(exp_r{1, 1}.performance.fp,th,test_num);
experiment_result_performance.F1measure=smooth_line(exp_r{1, 1}.performance.F1measure,th,test_num);
for i=2:size(exp_r,1)

AUC_new=smooth_line(exp_r{i, 1}.performance.AUC_block,th,test_num);   
experiment_result_performance.auc=[experiment_result_performance.auc;AUC_new];  
    
    
accuracy_new=smooth_line(exp_r{i, 1}.performance.accuracy,th,test_num);   
experiment_result_performance.accuracy=[experiment_result_performance.accuracy;accuracy_new];

precision_new=smooth_line(exp_r{i, 1}.performance.precision,th,test_num);   
experiment_result_performance.precision=[experiment_result_performance.precision;precision_new];   

recall_new=smooth_line(exp_r{i, 1}.performance.recall,th,test_num);   
experiment_result_performance.recall=[experiment_result_performance.recall;recall_new];

fp_new=smooth_line(exp_r{i, 1}.performance.fp,th,test_num);   
experiment_result_performance.fp=[experiment_result_performance.fp;fp_new];

F1measure_new=smooth_line(exp_r{i, 1}.performance.F1measure,th,test_num);   
experiment_result_performance.F1measure=[experiment_result_performance.F1measure;F1measure_new];

end
%{
label_cost=exp_r{1, 1}.result.al_performance.use_label_cost;


subplot(2,3,1);
for j=1:size(exp_r,1);
plot(label_cost,experiment_result_performance.accuracy(j,:),color{j});
hold on
end

subplot(2,3,2);
for j=1:size(exp_r,1);
plot(label_cost,experiment_result_performance.precision(j,:),color{j});
hold on
end

subplot(2,3,3);
for j=1:size(exp_r,1);
plot(label_cost,experiment_result_performance.recall(j,:),color{j});
hold on
end
subplot(2,3,4);
for j=1:size(exp_r,1);
plot(label_cost,experiment_result_performance.fp(j,:),color{j});
hold on
end

subplot(2,3,6);
for j=1:size(exp_r,1);
plot(label_cost,experiment_result_performance.F1measure(j,:),color{j});
hold on
end
%}