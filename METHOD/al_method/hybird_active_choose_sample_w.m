function [choose_part_serials,rank_final_result,weight]=hybird_active_choose_sample_w(choose_strategies,m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num,fuision_strategies,fuision_array)
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
       weight=1;
    else
       score_tmp=[]; 
       diff_tmp=[]; 
       rank_result=1:length(rest_part_train_sample_ind1);
       AL_type=nan(length(choose_strategies),1);
       for i=1:length(choose_strategies)
       [choose_part_serials,diff,~,rank_tmp,AL_type(i,1)]=active_choose_sample(choose_strategies(i),m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num);
       diff_tmp=[diff_tmp;diff'];
       rank_result=[rank_result;rank_tmp'];
       score_tmp=[score_tmp;sort(diff,'ascend')'];
       disp(['finish ',num2str(i),'th active learning']);
       end
       if length(fuision_array)==1
          if  fuision_array==0||fuision_array==1
          [weight] = calculate_weight(score_tmp,choose_num,AL_type,fuision_array); 
          else
          [weight] =ones(size(score_tmp,1),1)/size(score_tmp,1); 
          end
       elseif length(fuision_array)==length(choose_strategies)
          [weight] = fuision_array;
       else
          [weight] = calculate_weight(score_tmp,choose_num,AL_type,0); 
       end
       [new_rank,choose_part_serials]=agg_rank_w(fuision_strategies,rank_result,choose_num,weight,[]);
       if isempty(new_rank)~=1
       rank_final_result=new_rank(2,:);
       else
       rank_final_result=[1:length(rest_part_train_sample_ind1)];
       end
       
       
    end
end

       
       
 
        
    
    
    
    
    
    
    
end
