%options_active(1)表示每次选择几个

%{


[choose_part_serials,diff,diff_pos,rank,note]=committe_learning_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
%}

function [choose_part_serials,diff,diff_pos,rank,note]=committe_learning_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
note=0;
input_options_active_num=3;
default_options_active=[1,1,1];
%第一项为选择数目
%第二项为委员会成员策略
%统计差异方法
if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
  tmp = default_options_active; 
  tmp(1:length(options_active)) = options_active; 
  options_active = tmp; 
end 

now_part_train_sample1=m(now_part_train_sample_ind1,:);
rest_part_train_sample1=m(rest_part_train_sample_ind1,:);
choose_size=options_active(1);
committe_plan=options_active(2);
measuring_disagreement=options_active(3);
if committe_plan==0 % svm 4种比较最快
   options=[2,0,1,1/(size(now_part_train_sample1,2)-2)];
   result=nan(size(rest_part_train_sample1,1),4);
   for i=1:4
       options(1)=i-1;
       [net,need_type,~]=svm_building(now_part_train_sample1,options);
       [test_result,~,~] = svm_application(rest_part_train_sample1,net,need_type);
       result(:,i)=test_result;
       disp(i);
   end
elseif committe_plan==1 % svm 7种
   options=[2,0,1,1/(size(now_part_train_sample1,2)-2)];
   result=nan(size(rest_part_train_sample1,1),18);
   th=1;
   for i=0:3
       options(1)=i;
       for j=1:2
       options(3)=j;    
            for k=-1:1
            options(4)=2^k;    
            [net,need_type,~]=svm_building(now_part_train_sample1,options);
            [test_result,~,~] = svm_application(rest_part_train_sample1,net,need_type);
             result(:,th)=test_result;
             disp(i);
             th=th+1;
           end
       end
   end
elseif committe_plan==2 % svm 3种 
      svm_options1=[2,0,1,1/(size(now_part_train_sample1,2)-2)];
      %svm_options2=[0,0,1,1/(size(now_part_train_sample1,2)-2)];
      bays_options=[];
      %ADABOOST_options=1;
      BP_options=[50,0.1,1000,0.1];
      
      result=nan(size(rest_part_train_sample1,1),3);
       
      [net,need_type,~]=svm_building(now_part_train_sample1,svm_options1);
      [test_result,~,~] = svm_application(rest_part_train_sample1,net,need_type);
       result(:,1)=test_result;
      disp(1);
      
      [net,need_type,~]=bayes_building(now_part_train_sample1,bays_options);
      [test_result,~,~] = bays_application(rest_part_train_sample1,net,need_type);
      result(:,2)=test_result;
      disp(2);
     
      [net,need_type,~]=bp_building(now_part_train_sample1,BP_options);
      [test_result,~,~] = bp_application(rest_part_train_sample1,net,need_type);
      result(:,3)=test_result;
      disp(3);
      
end
disagreement_level=disagreement_test(result,measuring_disagreement);

diff=disagreement_level;
[~,diff_pos]=sort(disagreement_level,'ascend');
rank=score_invert_rank(diff,'low');

choose_part_serials=diff_pos(1:choose_size,1);


