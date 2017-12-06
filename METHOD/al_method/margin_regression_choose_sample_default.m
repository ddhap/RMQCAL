
%{
load('regression_tmpuse.mat')
m=train(:,1:50);
aa=20;
now_part_train_sample_ind1=[1:1+aa,47:47+aa,412:412+aa,1335:1335+aa];
rest_part_train_sample_ind1=setdiff((1:1805),now_part_train_sample_ind1);
options=[];
options_active(1,1)=2;
[choose_part_serialss,diff,diff_pos,rank,note]=margin_regression_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active);
%}




function [choose_part_serials,diff,diff_pos,rank,note] = margin_regression_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,options_active)
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

%%
now_part_train_sample1=m(now_part_train_sample_ind1,:);
rest_part_train_sample1=m(rest_part_train_sample_ind1,:);
choose_size=options_active(1);

model=ordinalregression_train(now_part_train_sample1(:,3:end),now_part_train_sample1(:,2));
[condition_te,~,~]=ordinalregression_test(rest_part_train_sample1(:,3:end),rest_part_train_sample1(:,2),model);
score=nan(size(condition_te,1),1);
method=3;
switch method
case 1
    
    abcd_te=convert_ctop(condition_te);
    for i=1:size(abcd_te,1)
        tmp=abcd_te(i,:);
        tmp1=sort(tmp,'descend');
        score(i,1)=tmp1(1)-tmp1(2);
    end
case 2
    
    for i=1:size(condition_te,1)
        tmp=condition_te(i,:);
        p1=find(tmp>1);
        if isempty(p1)==1
            score(i,1)=1/tmp(3);
            elseif p1(1)==1
            score(i,1)=tmp(1);
            elseif p1(1)==2
            score(i,1)=min(tmp(2),1/tmp(1));
        elseif p1(1)==3
            score(i,1)=min(tmp(3),1/tmp(2));
        end
    end
case 3
    
    abcd_te=convert_ctop(condition_te);
    for i=1:size(abcd_te,1)
        tmp=abcd_te(i,:);
        score(i,1)=var(tmp);
    end
end

case 4
diff=score;
[~,diff_pos]=sort(diff,'ascend');
rank=score_invert_rank(diff,'low');
choose_part_serials=diff_pos(1:choose_size,1);






function abcd=convert_ctop(data)
abcd=nan(size(data,1),4);

for i=1:size(data,1)
    L=data(i,1);M=data(i,2);N=data(i,3);
    abcd(i,1)=L/(L+1);
    abcd(i,2)=(M-L)/(1+M)/(L+1);
    abcd(i,3)=1/(M+1)-1/(N+1);
    abcd(i,4)=1/(N+1);
end
