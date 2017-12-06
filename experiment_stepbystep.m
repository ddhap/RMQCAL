%%标准的实验 parameter_input 为一个输入矩阵

function experiment_result_type=experiment_stepbystep(name,parameter_input)


if nargin==1
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
  sy_num=size(parameter_input,1)-1;
whether_use=input_detect(parameter_input);
if whether_use==0
   disp('[[[=======input is wrong=======]]]');
   experiment_result_type=[];
   return
else

Feon=exist(name,'file');
if Feon==0
   experiment_result_type_new=cell(size(parameter_input,1)-1,1);


elseif Feon==2
    load(name);
    Veon=exist('experiment_result_type','var');
    if Veon==0||sy_num~=size(experiment_result_type,1)
    experiment_result_type_new=cell(size(parameter_input,1)-1,1);    
    elseif Veon==1
    experiment_result_type_new=experiment_result_type;
    end
end

end

unfinished_pos=[];
for i=1:size(experiment_result_type_new,1)
     if isempty(experiment_result_type_new{i,1})==1
        unfinished_pos=[unfinished_pos;i];
     end
end
unfinished_pos_tmp=unfinished_pos+1;
unfinished_pos_tmp_num=length(unfinished_pos_tmp);
he=waitbar(0,'start one more experiment');

for h=1:unfinished_pos_tmp_num
    i=unfinished_pos_tmp(h);
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
    experiment_result_type_new{i-1,1}=tmp;
    experiment_result_type=experiment_result_type_new;
    save(name,'experiment_result_type');
    waitbar((h)/(unfinished_pos_tmp_num),he,['test ',num2str(i-1),' experiment, total is',num2str((size(parameter_input,1)-1))]);

end
    close(he);

    




    

    


