function [data_serial,data_rand_serial,train,test,solve,ps] = pretreatment_main(matrix,trainnum_per,testnum_per)
%PRETREATMENT_MAIN 此处显示有关此函数的摘要
%data 输入矩阵
data=initialization_matrix(matrix);
[data_re,ps] = mapminmax(data(:,3:end)',0,1);
data(:,3:end)=data_re';
data_serial=nan(size(data,1),size(data,2));
data_serial(:,1)=[1:size(data,1)]';
data_serial(:,2:end)=data(:,2:end);
data_rand_serial=data_serial(randperm(size(data,1))',:);
[train,test,solve]=randommat(data_rand_serial,trainnum_per,testnum_per);

