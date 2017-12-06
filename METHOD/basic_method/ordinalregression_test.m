function [margin_te,dec_te,accuracy_te]=ordinalregression_test(te,te_label,model)
B=model.B;
study_range=model.label_type;
label_num=model.label_num;
label_num2=label_num-1;
b=B(1:label_num2)';
A =[B(1:label_num2)'; repmat(B(label_num:end),1,label_num2)];
wx_te=zeros(size(te,1),1);
dec_te=nan(size(te,1),1);
margin_te=nan(size(te,1),1);
for ii=1:size(te,1)  
    wx_te(ii,1)=(B(label_num:end))'*(te(ii,:))';
end
dec_matrix=nan(size(te,1),label_num2);
for i=1:size(te,1)
dec_matrix(i,:)=wx_te(i,1)+b;
pos=find(dec_matrix(i,:)>=0);
if isempty(pos)==1
   pos1=label_num;
else
   pos1=pos(1);
end
dec_te(i,1)=study_range(pos1);
margin_te(i,1)=min(abs(dec_matrix(i,:)));




    
     



end

accuracy_te=mean(abs((dec_te-te_label)));

