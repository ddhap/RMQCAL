clc
clear
mu1 = [2 3];
SIGMA1 = [1 0; 0 2];
num=100;
mu2 = [6 7];
SIGMA2 = [1 0; 0 2];
[train_sample,label]=generatedata2D(mu1,mu2,SIGMA1,SIGMA2,num);
%%
%==========================
choose_strategies=[3,5,8];
fuision_strategies=14;
fuision_array=[];
initial=[1:20];

choose_num=2;
final_th=10;
[list]=generatelist(train_sample,label,initial,choose_num,final_th,choose_strategies,fuision_strategies,fuision_array);
drawAL(train_sample,label,initial,list);