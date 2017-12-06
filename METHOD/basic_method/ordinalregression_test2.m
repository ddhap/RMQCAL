function [abcd_te,dec_te,accuracy_te]=ordinalregression_test2(te,te_label,model)
B=model.B;
study_range=model.label_type;
label_num=model.label_num;
label_num2=label_num-1;
b=B(1:label_num2)';
A =[B(1:label_num2)'; repmat(B(label_num:end),1,label_num2)];
condition_te=zeros(size(te,1),size(A,2));
wx_te=zeros(size(te,1),1);
dec_te=nan(size(te,1),1);

for ii=1:size(te,1)
    for iii=1:size(A,2)
    condition_te(ii,iii)=exp([1,te(ii,:)]*A(:,iii));
    end
    wx_te(ii,1)=(B(label_num:end))'*(te(ii,:))';

end
abcd_te=convert_ctop(condition_te);
for i=1:size(te,1)
   dec_te(i,1)=study_range(find(abcd_te(i,:)==max(abcd_te(i,:))));
end
accuracy_te=length(find((dec_te-te_label)==0))/length(dec_te);







function abcd=convert_ctop(data)
abcd=nan(size(data,1),4);

for i=1:size(data,1)
    L=data(i,1);M=data(i,2);N=data(i,3);
    abcd(i,1)=L/(L+1);
    abcd(i,2)=(M-L)/(1+M)/(L+1);
    abcd(i,3)=1/(M+1)-1/(N+1);
    abcd(i,4)=1/(N+1);
end
