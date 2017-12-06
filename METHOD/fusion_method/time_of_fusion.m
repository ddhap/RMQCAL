%time
clc
clear
fusion_method_num=12;
sample_num=200;
rank_num=5;
rank=rank_generate(sample_num,rank_num);
choose_num=10;
usetime=nan(1,fusion_method_num);
choose_serial=nan(choose_num,fusion_method_num);

hwait=waitbar(0,'请等待>>>>>>>>');


for i=1:fusion_method_num
tic;
[new_rank,choose_serial(:,i)]=agg_rank(i,rank,choose_num);
usetime(1,i)=toc;
str=['正在运行中',num2str(round(i/fusion_method_num*100)),'%'];
waitbar(i/fusion_method_num,hwait,str);

end
