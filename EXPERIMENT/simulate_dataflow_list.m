%{ 
    clc
    clear
    option_dataflow.batch_size=4;
    option_dataflow.firstbatch_size=8;
    option_dataflow.firstbatch_selection_strategy='random';
    option_dataflow.first_choose_array=[];
    option_dataflow.extra_buffersize=0;

    option_dataflow.whethersave='N';
    [dataflow_list,info_sd]=simulate_dataflow_list(option_dataflow,train);


%}

function [dataflow_list,info_sd]=simulate_dataflow_list(option_dataflow,train)

if (nargin==0)
    option_dataflow.batch_size=0;
    option_dataflow.firstbatch_size=4;
    option_dataflow.firstbatch_selection_strategy='random';
    option_dataflow.first_choose_array=[];
    option_dataflow.whethersave='Y';
    option_dataflow.extra_buffersize=0;
end
if (nargin==0)||(nargin==1)
 [filename, pathname] = uigetfile({'*.mat','mat Files(*.mat)';},'Choose a mat file:');
    if filename ~= 0
         matdir = strcat(pathname,filename);
         tmp=load(matdir);
         if isfield(tmp,'train')==1
         train_sample=tmp.train;
         else
         dataflow_list=[];
         info_sd=[];
         errordlg('输入数据没找到train');
         return
         end
    else
        dataflow_list=[];
        info_sd=[];
        return
    end
else
filename='anonymous[id].mat';  
pathname=cd;
train_sample=train;
end
    
    
    

batch_size=option_dataflow.batch_size;
firstbatch_size=option_dataflow.firstbatch_size;
first_choose_array=option_dataflow.first_choose_array;
firstbatch_selection_strategy=option_dataflow.firstbatch_selection_strategy;
whethersave=option_dataflow.whethersave;
extra_buffersize=option_dataflow.extra_buffersize;
train_num=size(train_sample,1);
ind=1:train_num;
%fea_num=size(train_sample,2); 



if (firstbatch_size+batch_size+extra_buffersize>train_num)
    errordlg('input wrong');
    dataflow_list=[];
    info_sd=[];
elseif fix(firstbatch_size)~=firstbatch_size||fix(batch_size)~=batch_size||fix(extra_buffersize)~=extra_buffersize
    errordlg('input wrong');
    dataflow_list=[];
    info_sd=[];
elseif firstbatch_size<2||batch_size<0||extra_buffersize<0
    errordlg('input wrong');
    dataflow_list=[];
    info_sd=[];
else





%% 初始选择
    switch firstbatch_selection_strategy
        case 'random'
            [all_choose,~,~]=random_choose(train_sample,ind,firstbatch_size,2);
        case 'manual'  
            if isarraywell(first_choose_array,firstbatch_size,size(train_samples,1),1)==0
             errordlg('first_choose_array wrong, instead use random'); 
             [all_choose,~,~]=random_choose(train_sample,ind,firstbatch_size,2);
            else
             all_choose=first_choose_array; 
            end
        case 'cluster'
            if isarraywell(first_choose_array,1,1,0)==0
            errordlg('first_choose_array wrong, instead use random'); 
            [all_choose,~,~]=random_choose(train_sample,ind,firstbatch_size,2);  
            else
            fea=train_sample(:,3:end);
            label=train_sample(:,2);
            switch first_choose_array
                case 0
                [u, ~, ~]=fcm(fea,length(unique(label)));
                case 1
                [u,~]=KMeans(fea,length(unique(label)));
            end
                serial=find_close_point(fea,u,2);
                all_choose=serial';
            end
    end
    
rest_part_train_ind=setdiff(1:train_num,all_choose);
%% 生成批次

    if batch_size==0%基于池
       all_batch_num=1;
       choose_batch_list=cell(all_batch_num,1);
       choose_batch_list{1,1}=all_choose;  
    elseif batch_size~=0%基于流 
        
      if extra_buffersize==0 
       all_batch_num=ceil((train_num-firstbatch_size)/batch_size)+1;
       choose_batch_list=cell(all_batch_num,1);
       choose_batch_list{1,1}=all_choose; 
       rest_part_train_ind_re=rest_part_train_ind(randperm(size(rest_part_train_ind,2)));
       for i=2:(all_batch_num-1)
           choose_batch_list{i,1}=rest_part_train_ind_re(1,1:batch_size);
           rest_part_train_ind_re=rest_part_train_ind_re(1,(batch_size+1):end);
       end
       choose_batch_list{all_batch_num,1}=rest_part_train_ind_re;     
       
      elseif extra_buffersize~=0 
       all_batch_num=ceil((train_num-firstbatch_size-extra_buffersize)/batch_size)+1;
       choose_batch_list=cell(all_batch_num,1);
       choose_batch_list{1,1}=all_choose; 
       rest_part_train_ind_re=rest_part_train_ind(randperm(size(rest_part_train_ind,2)));
       for i=2:(all_batch_num-1)
           
           if i==2
           choose_batch_list{i,1}=rest_part_train_ind_re(1,1:(batch_size+extra_buffersize));
           rest_part_train_ind_re=rest_part_train_ind_re(1,(batch_size+extra_buffersize+1):end);    
           else
           choose_batch_list{i,1}=rest_part_train_ind_re(1,1:batch_size);
           rest_part_train_ind_re=rest_part_train_ind_re(1,(batch_size+1):end);
           end
       end
       choose_batch_list{all_batch_num,1}=rest_part_train_ind_re;   
    
      end
    end
    
    
    
       
       
    
    
    dataflow_list=choose_batch_list;
    info_sd.option=option_dataflow;
    info_sd.resource=filename;
    info_sd.address='yes';
    filename2=filename(1:length(filename)-4);
%%  保存
    if strcmp(whethersave,'Y')==1
    defAns={[filename2,'[sd]']};
    name=inputdlg('Type fold name','Name',1,defAns); 
    fid=fopen([num2str(pathname),'\',num2str(cell2mat(name)),'.mat'],'rt');
    while fid ~= -1 %% ('重名文件存在则继续循环') 
    %answer = inputdlg(prompt,dlg_title,num_lines,defAns)
  
    name=inputdlg('name exist,please type fold name again ','Name',1,defAns); 
    fid=fopen([num2str(pathname),'\',num2str(cell2mat(name)),'.mat'],'rt');
    fclose('all');
    end
    save([num2str(pathname),'\',num2str(cell2mat(name)),'.mat'],'dataflow_list','info_sd');
    
        
    end
    



end









    
end

