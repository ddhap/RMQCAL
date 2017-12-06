%{
load('regression_tmpuse.mat')
m=train(:,1:50);
aa=20;
now_part_train_sample_ind1=[1:1+aa,47:47+aa,412:412+aa,1335:1335+aa];
rest_part_train_sample_ind1=setdiff((1:1805),now_part_train_sample_ind1);
options=[];
options_active(1,1)=2;
 [choose_part_serials,diff,diff_pos,rank,note] =EMC_regression_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
%}




function [choose_part_serials,diff,diff_pos,rank,note] = EMC_regression_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
%标识样本索引 未标识样本索引 b

%%
note=0;
input_options_active_num=1;
default_options_active=1;


if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
  tmp = default_options_active; 
  tmp(1:length(options_active)) = options_active; 
  options_active = tmp; 
end 
zhucengfeng_NUM=1;
%%
now_part_train_sample=m(now_part_train_sample_ind1,:);
rest_part_train_sample=m(rest_part_train_sample_ind1,:);
PA=now_part_train_sample(:,3:end);
PB=rest_part_train_sample(:,3:end);

[a1,b1,~,~]=princomp(PA);
P0=b1(:,1:zhucengfeng_NUM);%
PA_mean=mean(PA);
PA_rebuilt=[now_part_train_sample(:,1:2),P0];

PB_num=size(PB,1);
if PB_num==0
PB_rebuilt=[];  
else 
for i=1:PB_num 
    xmean_PB(i,:)=PB(i,:)-PA_mean;
end
    b2=xmean_PB*a1;
    P1=b2(:,1:zhucengfeng_NUM);
    PB_rebuilt=[rest_part_train_sample(:,1:2),P1];%%新训练集
end

now_part_train_sample1=PA_rebuilt;
rest_part_train_sample1=PB_rebuilt;

choose_size=options_active(1);
type=sort(unique(m(:,2)),'ascend');
type_num=length(unique(m(:,2)));
model=ordinalregression_train(now_part_train_sample1(:,3:end),now_part_train_sample1(:,2));
[abcd_te,dec_te,accuracy_te]=ordinalregression_test2(rest_part_train_sample1(:,3:end),rest_part_train_sample1(:,2),model);
h = waitbar(0,'anaylsis remaining unlabeled sample');
score=nan(size(rest_part_train_sample1,1),1);
for ii=1:size(rest_part_train_sample1,1)
    one_model_diff=nan(type_num,1);
    for iii=1:type_num
    new_model=ordinalregression_train([now_part_train_sample1(:,3:end);rest_part_train_sample1(ii,3:end)],[now_part_train_sample1(:,2);type(iii)]);
    one_model_diff(iii,1)=pdist2((new_model.B)',(model.B)');
    end
    score(ii,1)=one_model_diff'*(abcd_te(ii,:))';
    waitbar((ii)/(size(rest_part_train_sample1,1)),h,['analysis ',num2str(ii),' sample, total is',num2str(size(rest_part_train_sample1,1))]);

end



diff=-score;
[~,diff_pos]=sort(diff,'ascend');
rank=score_invert_rank(diff,'low');
choose_part_serials=diff_pos(1:choose_size,1);





