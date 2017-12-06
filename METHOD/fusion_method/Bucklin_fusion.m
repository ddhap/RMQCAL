%{
clc
clear
sample_num=5;
rank_num=2;
rank=rank_generate(sample_num,rank_num);
choose_num=2;
[new_rank,choose_serial]=Bucklin_fusion(rank,choose_num)

%}
function [new_rank,choose_serial]=Bucklin_fusion(rank,choose_num)
new_rank_name=rank(1,:);
rank_tmp=rank(2:end,:);
sample_num=size(rank_tmp,2);
rank_new=zeros(1,sample_num);%第一名第二名分别是哪一位，相当于P2
tot=1;
for k=1:sample_num%排名score
    for j=1:sample_num%样本量
        flag=0;
        flag_r=0;
        for l=1:tot
            if(rank_new(1,l)==j)
                flag_r=1;
            end
        end
        if(flag_r==0)
             for i=1:size(rank_tmp,1)
               if( find(rank_tmp(i,j)<=k)==1)
                   flag=flag+1;           
               end      
            end
            if(flag>ceil(size(rank_tmp,1)/2))
                rank_new(1,tot)=j;
                tot=tot+1;
                if tot>sample_num
                   new_rank=zeros(1,sample_num);
                   for i=1:sample_num
                        new_rank(1,i)=find(rank_new==i);
                   end
                  new_rank=[new_rank_name;new_rank];
                  choose_serial=new_rank_name(rank_new(1:choose_num)); 
                   return
                end
            end
        end
    end
end
new_rank=zeros(1,sample_num);
for i=1:sample_num
    new_rank(1,i)=find(rank_new==i);
end

new_rank=[new_rank_name;new_rank];
choose_serial=new_rank_name(rank_new(1:choose_num));

        