%{
clc
clear
load('anonymous[id].mat');
load('anonymous[id][sd]0.mat');

option_al.choose_num=1;
option_al.choose_strategies=[13];
option_al.fuision_strategies=1;
option_al.fuision_array=1;
train_sample=train;
test_sample=test;
option_ml.method='svm';
option_ml.parameter=[];
option_al.end_requirement_way=5;
option_al.end_requirement_options=0.3;
result=active_learning_regression(train_sample,test_sample,info_id,dataflow_list,info_sd,option_al,option_ml);
%}



function result=active_learning_regression(train_sample,test_sample,info_id,dataflow_list,info_sd,option_al)
%% 选择输入

default_option_al.choose_num=2;
default_option_al.choose_strategies=2;
default_option_al.fuision_strategies=1;
default_option_al.fuision_array=[];
default_option_al.end_requirement_way=1;
default_option_al.end_requirement_options=[];

if nargin==5
option_al=default_option_al;

elseif nargin==3
option_al=default_option_al;
    [filename, pathname] = uigetfile({'*.mat','mat Files(*.mat)';},'choose dataflow fold:');
    if filename ~= 0
         matdir = strcat(pathname,filename);
         tmp=load(matdir);
         if isfield(tmp,'dataflow_list')==1&&isfield(tmp,'info_sd')==1
         dataflow_list=tmp.dataflow_list;
         info_sd=tmp.info_sd;
         disp('==========finish choose dataflow fold==========');
         else
         result=[];    
         errordlg('输入数据没找到data');
         return
         end
    else
        result=[];  
        return
    end
elseif nargin==0   
    
option_al=default_option_al;

     [filename, pathname] = uigetfile({'*.mat','mat Files(*.mat)';},'choose database fold:');
    if filename ~= 0
         matdir = strcat(pathname,filename);
         tmp=load(matdir);
         if isfield(tmp,'train')==1&&isfield(tmp,'info_id')==1&&isfield(tmp,'test')==1
         test_sample=tmp.test;
         train_sample=tmp.train;
         info_id=tmp.info_id;
         disp('==========finish choose database fold==========');
         else
         result=[];    
         errordlg('输入数据没找到data');
         return
         end
    else
        result=[];  
        return
    end




    [filename, pathname] = uigetfile({'*.mat','mat Files(*.mat)';},'choose dataflow fold:');
    if filename ~= 0
         matdir = strcat(pathname,filename);
         tmp=load(matdir);
         if isfield(tmp,'dataflow_list')==1&&isfield(tmp,'info_sd')==1
         dataflow_list=tmp.dataflow_list;
         info_sd=tmp.info_sd;
         disp('==========finish choose dataflow fold==========');
         else
         result=[];    
         errordlg('输入数据没找到data');
         return
         end
    else
        result=[];  
        return
    end
    
    
    
    
elseif  nargin~=6 
    errordlg('input is wrong')
    result=[];
    return
end



choose_num=option_al.choose_num;                  %批量选择大小
choose_strategies=option_al.choose_strategies;    %al 策略1~14
fuision_strategies=option_al.fuision_strategies;  %用法策略目前1~15
fuision_array=option_al.fuision_array;   %用于确定融合权重
%dataflow_list    %数据流
train_num=size(train_sample,1); 
%% 确定方法
if size(dataflow_list,1)==1
   type='pool_based';
else
   batch_size=size(dataflow_list{3,1},2);
   if batch_size==choose_num
   type='buffer_based';
   elseif batch_size>choose_num
   type='stream_based';    
   end
end


%% 初始参数
whether_end=0;
first_part_train_sample_ind=dataflow_list{1,1};
now_part_train_sample_ind=first_part_train_sample_ind;

accuracytr_block=[];    
accuracyte_block=[]; 
test_result_block=[];
use_sample_block=[];%选择用的样本
use_sample_label=[];%用的样本标注
use_label_cost=[];  %花费的标注成本
use_weight=[];
batch_time=1;
later_remainder=[];
%% active 过程 %ind结尾是原始序列
rest_part_train_sample_ind=setdiff(1:train_num,now_part_train_sample_ind);

hwait=waitbar(0,'start active learning');
tic;
while (size(rest_part_train_sample_ind,2)>=choose_num)&&whether_end==0
     if strcmp(type,'pool_based')
        candidate_train_sample_ind=rest_part_train_sample_ind;
        [choose_part_serials,~,weight]=hybird_active_choose_sample_w(choose_strategies,train_sample,now_part_train_sample_ind,candidate_train_sample_ind,choose_num,fuision_strategies,fuision_array);
       %% 更新
        choose_part_ind=candidate_train_sample_ind(1,choose_part_serials); 
        now_part_train_sample_ind=[now_part_train_sample_ind,choose_part_ind];
        rest_part_train_sample_ind=setdiff(rest_part_train_sample_ind,choose_part_ind); 
     
     elseif strcmp(type,'buffer_based')
        candidate_train_sample_ind=[dataflow_list{batch_time+1,1},later_remainder];
        [choose_part_serials,~,weight]=hybird_active_choose_sample_w(choose_strategies,train_sample,now_part_train_sample_ind,candidate_train_sample_ind,choose_num,fuision_strategies,fuision_array);
       %% 更新
        choose_part_ind=candidate_train_sample_ind(1,choose_part_serials); 
        now_part_train_sample_ind=[now_part_train_sample_ind,choose_part_ind];
        later_remainder=setdiff(candidate_train_sample_ind,choose_part_ind);
        rest_part_train_sample_ind=setdiff(rest_part_train_sample_ind,choose_part_ind); 
        batch_time=batch_time+1;
    elseif strcmp(type,'stream_based')
        candidate_train_sample_ind=dataflow_list{batch_time+1,1};
        [choose_part_serials,~,weight]=hybird_active_choose_sample_w(choose_strategies,train_sample,now_part_train_sample_ind,candidate_train_sample_ind,choose_num,fuision_strategies,fuision_array);
       %% 更新
        choose_part_ind=candidate_train_sample_ind(1,choose_part_serials); 
        now_part_train_sample_ind=[now_part_train_sample_ind,choose_part_ind];
        rest_part_train_sample_ind=setdiff(rest_part_train_sample_ind,candidate_train_sample_ind);
        batch_time=batch_time+1;
     end
      %%测试
         
      model=ordinalregression_train(train_sample(now_part_train_sample_ind,3:end),train_sample(now_part_train_sample_ind,2));
      [~,dec_te,accuracyte]=ordinalregression_test(test_sample(:,3:end),test_sample(:,2),model);
     [~,dec_tr,accuracytr]=ordinalregression_test(train_sample(now_part_train_sample_ind,3:end),train_sample(now_part_train_sample_ind,2),model);
      
      
          label_cost=size(now_part_train_sample_ind,2);
         waitbar(label_cost/train_num,hwait,['Annotated ',num2str(label_cost),' samples, total is',num2str(train_num)]);

         %% 记录
         accuracytr_block=[accuracytr_block,accuracytr];
         accuracyte_block=[accuracyte_block,accuracyte];
         disp(accuracyte);
         test_result_block=[test_result_block,dec_te];%行代表每个test 列表示每次结果
         use_sample_block=[use_sample_block,choose_part_ind'];
         use_sample_label=[use_sample_label,train_sample(choose_part_ind,2)];
         use_label_cost=[use_label_cost,label_cost];
         use_weight=[use_weight,weight];
         
         whether_end=end_requirement(train_num,accuracyte_block,use_label_cost,option_al.end_requirement_way,option_al.end_requirement_options);
end
usetime=toc;
         close(hwait);
         al_performance.usetime=usetime;
         al_performance.accuracytr_block=accuracytr_block;
         al_performance.accuracyte_block=accuracyte_block;
         al_performance.test_result_block=test_result_block;
         al_performance.use_sample_block=use_sample_block;
         al_performance.use_sample_label=use_sample_label;
         al_performance.use_label_cost=use_label_cost;
         al_performance.use_weight=use_weight;
         result.info_id=info_id;
         result.info_id=info_sd;
         result.dataflow_list=dataflow_list;
         result.option_al=option_al;
         result.al_performance=al_performance;