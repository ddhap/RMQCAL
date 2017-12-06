
choose_strategies=[8];
fuision_strategies=0;
fuision_array=[];
initial=[1:20];

choose_num=1;
final_th=4;
mu = [2 3];
SIGMA = [1 0; 0 2];
r = mvnrnd(mu,SIGMA,num);
%plot(r(:,1),r(:,2),'r+');
%hold on;
mu = [6 7];
SIGMA = [ 1 0; 0 2];



r2 = mvnrnd(mu,SIGMA,num);
%plot(r2(:,1),r2(:,2),'*')
%P=randperm(num*2);


%
P=[8,89,77,27,6,41,17,15,82,29,16,67,72,53,23,19,40,28,71,58,12,54,14,66,43,95,7,87,26,22,11,90,52,69,61,18,86,20,100,31,39,93,49,63,94,50,48,10,62,80,98,46,13,78,92,85,24,34,60,35,64,45,37,32,44,55,33,3,42,47,88,30,4,65,59,70,2,68,9,56,76,81,25,38,74,36,21,5,73,91,84,1,51,96,57,97,83,99,79,75];
label=[ones(num,1);zeros(num,1)];
while(length(unique(label(P(1:2))))==1)
    P=randperm(num*2);
end
fea=[r;r2];
label=[ones(num,1);zeros(num,1)];

    
    
train_sample=fea(P,:);
train=[(1:num*2)',label,train_sample];
label=label(P,:);

first_part_train_sample_ind=initial;
now_part_train_sample_ind=first_part_train_sample_ind;
rest_part_train_sample_ind=setdiff(1:num*2,now_part_train_sample_ind);
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

figure

for i=1:size(train_sample,1)
plot(train_sample(i,1),train_sample(i,2),'k.','MarkerSize',8);
axis([0 10 0 10])
hold on
end





for i=1:size(first_part_train_sample_ind,2)
    if label(first_part_train_sample_ind(1,i),1)==1
        
       plot(train_sample(first_part_train_sample_ind(1,i),1),train_sample(first_part_train_sample_ind(1,i),2),'r*','MarkerSize',8);
    else
       plot(train_sample(first_part_train_sample_ind(1,i),1),train_sample(first_part_train_sample_ind(1,i),2),'b*','MarkerSize',8); 
    end
    hold on
end


for i=1:size(list,1)
    plot(train_sample(list(i),1),train_sample(list(i),2),'go','MarkerSize',11);
     hold on

    if label(list(i),1)==1
    text(train_sample(list(i),1),train_sample(list(i),2),['\fontsize{10} \color{red}',num2str(i)]);
    else
        
    text(train_sample(list(i),1),train_sample(list(i),2),['\fontsize{10} \color{blue}',num2str(i)]);

    end
    hold on
end
title('');

