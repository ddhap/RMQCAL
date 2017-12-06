function drawAL(train_sample,label,initial,list)
%%unlabeled
for i=1:size(train_sample,1)
if label(i,1)==1
plot(train_sample(i,1),train_sample(i,2),'m.','MarkerSize',8);
else
plot(train_sample(i,1),train_sample(i,2),'c.','MarkerSize',8);
end
hold on
end

%% first choose
first_part_train_sample_ind=initial;
for i=1:size(first_part_train_sample_ind,2)
    if label(first_part_train_sample_ind(1,i),1)==1
        
       plot(train_sample(first_part_train_sample_ind(1,i),1),train_sample(first_part_train_sample_ind(1,i),2),'r*','MarkerSize',8);
    else
       plot(train_sample(first_part_train_sample_ind(1,i),1),train_sample(first_part_train_sample_ind(1,i),2),'b*','MarkerSize',8); 
    end
    hold on
end

%%  al process

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


