function [train,test,solve]=randommat(mat,trainnum_per,testnum_per)%将样本分为训练集与测试集
onelabtrain={};
onelabtest={};
labe=unique(mat(:,2));
labe_NUM=size(labe,1);
for i=1:labe_NUM
if isnan(labe(i))==1    
[mm,mn]=find(isnan(mat(:,2))==1);
alllabsolve=mm;
else
[mm,mn]=find(mat(:,2)==labe(i));
mm_num=size(mm,1);
train_num=round(mm_num*trainnum_per/(trainnum_per+testnum_per));
%test_num=mm_num-train_num;
a=randperm(mm_num);
onelabtrain{i}=mm(a(1,1:train_num),1);
onelabtest{i}=mm(a(1,train_num+1:end),1);
alllabsolve=[];

end
end
    alllabtrain=[];
    alllabtest=[];
    
    for i=1:labe_NUM
        if isnan(labe(i))~=1  
        alllabtrain=[alllabtrain;onelabtrain{i}];
        alllabtest=[alllabtest;onelabtest{i}];
        end
    end
train=mat(alllabtrain,:);
test=mat(alllabtest,:);
solve=mat(alllabsolve,:);