
%{
clc
clear
sample_num=7;
rank_num=3;
rank=rank_generate(sample_num,rank_num);
choose_num=3;
method=3;
weight=[1,1,1];
 [new_rank,choose_serial]=Bucklin_fusion_w(rank,choose_num,weight);

%}



function [new_rank,choose_serial]=Bucklin_fusion_w(rank,choose_num,weight)

if size(weight,2)==1
   weight=weight'/sum(weight);
elseif size(weight,2)~=1&&size(weight,1)~=1
   weight=ones(1,size(rank,1)-1)/sum(weight);   
elseif size(weight,2)~=size(rank,1)-1&&size(weight,1)~=size(rank,1)-1
   weight=ones(1,size(rank,1)-1)/sum(weight);  
else
   weight=weight/sum(weight); 

end

new_rank_name=rank(1,:);
rank_tmp1=rank(2:end,:);
sample_num=size(rank_tmp1,2);
rank_num=size(rank_tmp1,1);
score_new=zeros(1,sample_num);% 每一个名字的排名
new_rank_tmp=ones(1,sample_num)*(choose_num+1);


choose_serial=nan(1,choose_num);%T
rank_tmp=rank_tmp1;
for ii=1:choose_num
    
   ch=1;
   score_new=zeros(1,sample_num);% 每一个名字的排名
   while(isnan(choose_serial(ii))==1)
   for j=1:rank_num      
       index=find(rank_tmp(j,:)==ch);
       score_new(ch,index)=score_new(ch,index)+weight(j); 
   end
   score_new_sum=sum(score_new,1);
   index2=find(score_new_sum>0.5);
   if isempty(index2)==0
       choose_serial(1,ii)=new_rank_name(index2(1));
       new_rank_tmp(1,index2(1))=ii;
       rank_tmp(:,index2(1))=ones(rank_num,1)*999999;
   else
       ch=ch+1;
       score_new=[score_new;zeros(1,sample_num)];
   end
   end
   
end
       
new_rank=[new_rank_name;new_rank_tmp];    
    
           