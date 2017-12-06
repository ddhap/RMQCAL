%{
choose_strategies=[2];
fuision_strategies=14;
fuision_array=[];
initial=[1:20];

choose_num=2;
final_th=3;
[list]=generatelist(train_sample,label,initial,choose_num,final_th,choose_strategies,fuision_strategies,fuision_array);

%}



function [list]=generatelist(train_sample,label,initial,choose_num,final_th,choose_strategies,fuision_strategies,fuision_array)

train=[(1:length(label))',label,train_sample];

first_part_train_sample_ind=initial;
now_part_train_sample_ind=first_part_train_sample_ind;
rest_part_train_sample_ind=setdiff(1:length(label),now_part_train_sample_ind);
th=0;
chooselist=nan(final_th,choose_num);
while (size(rest_part_train_sample_ind,2)&&th~=final_th)
     th=th+1;
     candidate_train_sample_ind=rest_part_train_sample_ind;
     [choose_part_serials,~]=hybird_active_choose_sample(choose_strategies,train,now_part_train_sample_ind,candidate_train_sample_ind,choose_num,fuision_strategies,fuision_array);
    
     choose_part_ind=candidate_train_sample_ind(1,choose_part_serials);  
     chooselist(th,:)=choose_part_ind;
     now_part_train_sample_ind=[now_part_train_sample_ind,choose_part_ind];
     rest_part_train_sample_ind=setdiff(rest_part_train_sample_ind,choose_part_ind); 
end
list=reshape(chooselist',[choose_num*final_th,1]);

