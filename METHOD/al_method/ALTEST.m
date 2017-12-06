load('wine_data.mat');
m=data;
choose_num=2;
choose_strategies=[2,3,4,5,6,7,11];
now_part_train_sample_ind1=56:65;
rest_part_train_sample_ind1=[(1:55),(66:130)];
rank_result=1:length(rest_part_train_sample_ind1);
for i=1:length(choose_strategies)
       [~,~,~,rank_tmp,~]=active_choose_sample(choose_strategies(i),m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num);
       rank_result=[rank_result;rank_tmp'];
       disp(['finish ',num2str(i),'th active learning']);
end

