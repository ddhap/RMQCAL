%{
clc
clear
option.dimenreduction=100;
option.trainnum_per=2;
option.testnum_per=1;
option.whethersave='Y';
[train,test,info_id]=initialize_database(option);
[net,need_type,options_out]=svm_building(train,[]);
[test_result,diff,need_type] = svm_application(test,net,need_type);
%}



function [train,test,info_id]=initialize_database(option,data)

%%
%打开
if nargin==0
   option.dimenreduction=100;
   option.trainnum_per=2;
   option.testnum_per=1; 
   option.whethersave='Y';
end
if nargin==1||nargin==0

    [filename, pathname] = uigetfile({'*.mat','mat Files(*.mat)';},'Choose a mat file:');
    if filename ~= 0
         matdir = strcat(pathname,filename);
         tmp=load(matdir);
         if isfield(tmp,'data')==1
         data=tmp.data;
         else
         train=[];test=[];info_id=[]; 
         errordlg('输入数据没找到data');
         return
         end
    else
        train=[];test=[];info_id=[]; 
        return
    end
else
filename='anonymous.mat';   
pathname=cd;
end

%% 检测数据
if size(data,2)<3
   train=[];test=[];info_id=[]; 
   errordlg('数据有问题');
   return
else
    

filename2=filename(1:length(filename)-4);
%% 去除数据中的无信息点
data_new=initialization_matrix(data);
%% 分割
[~,~,Train,Test,~,~]=pretreatment_main(data_new,option.trainnum_per,option.testnum_per);
[PA_rebuilt,PB_rebuilt,~]=PCAdimen(Train,Test,option.dimenreduction);
train=PA_rebuilt;test=PB_rebuilt;

%% 检测训练集与测试集
if size(train,2)<3||size(test,2)<3||length(unique(train(:,2)))<2||length(unique(train(:,2)))<2
    train=[];test=[];info_id=[]; 
    errordlg('输入数据有问题');
    return
end
%% 备注
info_id.option=option;
info_id.resource=filename;
info_id.address='yes';
%% 输出
if strcmp(option.whethersave,'Y')==1
defAns={[filename2,'[id]']};
name=inputdlg('Type fold name','Name',1,defAns); 
fid=fopen([num2str(pathname),'\',num2str(cell2mat(name)),'.mat'],'rt');
while fid ~= -1 %% ('重名文件存在则继续循环') 
%answer = inputdlg(prompt,dlg_title,num_lines,defAns)
  
name=inputdlg('name exist,please type fold name again ','Name',1,defAns); 
fid=fopen([num2str(pathname),'\',num2str(cell2mat(name)),'.mat'],'rt');
fclose('all');
end
save([num2str(pathname),'\',num2str(cell2mat(name)),'.mat'],'train','test','info_id');
end
end

