
%该只能用默认active 参数
%{
load('alg_test2.mat')
m=train;
choose_num=2;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
choose_strategies=[12];
fuision_strategies=1;
fuision_array=[];
[choose_part_serials,rank_result]=hybird_active_choose_sample(choose_strategies,m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num,fuision_strategies,fuision_array);
%}





function [choose_part_serials,rank_final_result]=hybird_active_choose_sample(choose_strategies,m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num,fuision_strategies,fuision_array)
%choose_part_serials是剩余样本中中的排序 不是总排序
if (nargin<5) 
   error('input parameters is not enough');
elseif length(choose_strategies)>=2&&(nargin<6)
   error('not any parameters of fusion');
else
    if length(choose_strategies)==1
       [choose_part_serials,~,~,rank_tmp,~]=active_choose_sample(choose_strategies,m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num);
       rank_result=[1:length(rest_part_train_sample_ind1);rank_tmp'];
       new_rank=rank_result;
       rank_final_result=new_rank(2,:);

    else
       rank_result=1:length(rest_part_train_sample_ind1);
       for i=1:length(choose_strategies)
       [~,~,~,rank_tmp,~]=active_choose_sample(choose_strategies(i),m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num);
       rank_result=[rank_result;rank_tmp'];
       disp(['finish ',num2str(i),'th active learning']);
       end
       [new_rank,choose_part_serials]=agg_rank(fuision_strategies,rank_result,choose_num,[]);
       if isempty(new_rank)~=1
       rank_final_result=new_rank(2,:);
       else
       rank_final_result=[1:length(rest_part_train_sample_ind1)];
       end
       
       
    end
end

       
       
 
        
    
    
    
    
    
    
    
end
