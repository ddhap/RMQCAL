load('alg_test2.mat')
m=train;
choose_num=2;
now_part_train_sample_ind1=125:225;
rest_part_train_sample_ind1=[(1:124),(226:350)];
rest_num=size(rest_part_train_sample_ind1,2);
active_method_num=13;

query_select=2;
usetime=nan(1,active_method_num);
choose_part_serials_block=nan(choose_num,active_method_num);
rank_block=nan(rest_num,active_method_num);
note_block=nan(1,active_method_num);
diff_block=nan(rest_num,active_method_num);
diff_pos_block=nan(rest_num,active_method_num);
hwait=waitbar(0,'请等待>>>>>>>>');

for i=1:active_method_num
tic    
[choose_part_serials,diff,diff_pos,rank,note]=active_choose_sample(i,m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num);
usetime(1,i)=toc;
str=['正在运行中',num2str(round(i/active_method_num*100)),'%'];
waitbar(i/active_method_num,hwait,str);
choose_part_serials_block(:,i)=choose_part_serials;
rank_block(:,i)=rank;
note_block(:,i)=note;
diff_block(:,i)=diff;
diff_pos_block(:,i)=diff_pos;

end