

function experiment_result_type=experiment(parameter_input)


if nargin==0
[filename, pathname] = uigetfile({'*.mat','mat Files(*.mat)';},'Choose a mat file:');
    if filename ~= 0
         matdir = strcat(pathname,filename);
         tmp=load(matdir);
         if isfield(tmp,'parameter_input')==1
         parameter_input=tmp.parameter_input;
         else
         experiment_result_type=[];
         errordlg(' never find parameter_input');
         return
         end
    else
        experiment_result_type=[];
        return
    end
end
















%% ======================================================
%% read the block
whether_use=input_detect(parameter_input);
if whether_use==0
disp('[[[=======input is wrong=======]]]');
experiment_result_type=[];
return
end
experiment_result_type=cell(size(parameter_input,1)-1,1);


he=waitbar(0,'start one more experiment');
for i=2:size(parameter_input,1)
    
    for j=1:15
        eval([parameter_input{1,j},'=','parameter_input{',num2str(i),',',num2str(j),'};']);
    end
    
    load(data_name);
    if isempty(dataflow_name)==0
    load(dataflow_name);
    else
    option_dataflow.whethersave='N';
    [dataflow_list,info_sd]=simulate_dataflow_list(option_dataflow,train);
    end

    train_sample=train;
    test_sample=test;
    result=active_learning_process(train_sample,test_sample,info_id,dataflow_list,info_sd,option_al,option_ml);
    disp('=======Active learning finish=======');

%% result_analysis

    label_stand=test_sample(:,2);
    label_type=sort(unique(label_stand));
    positive_class=label_type(1);
    test_result_block=result.al_performance.test_result_block;
    AUC_block=result.al_performance.AUC_block;
    [confusion_table_test,accuracy1,precision1,recall1,fp1,F1measure]=result_analysis(test_result_block,label_stand,positive_class);
    disp('=======result analysis finish=======');
    performance.confusion_table_test=confusion_table_test;
    performance.accuracy=accuracy1;
    performance.precision=precision1;
    performance.recall=recall1;
    performance.fp=fp1;
    performance.F1measure=F1measure;
    performance.AUC_block=AUC_block;
    tmp.performance=performance;
    tmp.result=result;
    experiment_result_type{i-1,1}=tmp;
    save('tmp.mat','experiment_result_type');
    waitbar((i-1)/(size(parameter_input,1)-1),he,['test ',num2str(i-1),' experiment, total is',num2str((size(parameter_input,1)-1))]);

end
    close(he);

    




    

    


