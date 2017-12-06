%% make a list
clc
clear
%% =================more experimental tests=================
%% ======================================================

parameter_input=cell(1,15);
parameter_input{1,1}='data_name';
parameter_input{1,2}='dataflow_name';

parameter_input{1,3}='option_dataflow.batch_size';
parameter_input{1,4}='option_dataflow.firstbatch_size';
parameter_input{1,5}='option_dataflow.firstbatch_selection_strategy';
parameter_input{1,6}='option_dataflow.first_choose_array';
parameter_input{1,7}='option_dataflow.extra_buffersize';

parameter_input{1,8}='option_al.choose_num';
parameter_input{1,9}='option_al.choose_strategies';
parameter_input{1,10}='option_al.fuision_strategies';
parameter_input{1,11}='option_al.fuision_array';
parameter_input{1,12}='option_ml.method';
parameter_input{1,13}='option_ml.parameter';
parameter_input{1,14}='option_al.end_requirement_way';
parameter_input{1,15}='option_al.end_requirement_options';


%% ======================================================
%% open and write
disp('[[[=======please write the block of parameter_input=======]]]');


