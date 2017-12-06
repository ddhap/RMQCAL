function model=ordinalregression_train(tr,tr_label)

%% input
label_type=(sort(unique(tr_label)))';
label_num=length(label_type);
label_cell=cell(1,label_num);
for i=1:label_num
    label_cell{1,i}=char(label_type(1,i));
end
diff=(label_type(1,label_num)-label_type(1,1))/(label_num-1)/2;
range_value=nan(1,label_num+1);
for i=1:(label_num+1)
    if i==1
       range_value(1,i)=label_type(1,i)-diff;  
    elseif i==label_num+1
       range_value(1,i)=label_type(1,label_num)+diff;  
    else
       range_value(1,i)=(label_type(1,i)+label_type(1,i-1)) /2;
    end
end

%% training
miles = ordinal(tr_label,label_cell,[],range_value);
[B,dev,stats] = mnrfit(tr,miles,'model','ordinal');


model.B=B;
model.dev=dev;
model.stats=stats;
model.label_type=label_type;
model.label_num=label_num;



