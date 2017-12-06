%   rank=[1,3,5,7,9;5,2,1,3,4;5,2,1,3,4;5,2,1,3,4];
%   rank=[1,3,5,7,9;1,2,3,4,5;5,2,1,3,4;2,2,1,4,5];
%rank=[1,2,3,5;1,2,3,4;3,4,1,2;1,4,2,3];
%rank=[1,3,5,7,9;5,4,3,2,1;1,2,3,4,5;];

%{  

rank=[1:100]*100;
for i=1:3
rank=[rank;randperm(100)];
end


a=0.05;
choose_num=2;
top_k=choose_num*2
MCmethod=3;
weight=[1,1,1];
[new_rank,choose_serial]=MCMC_fusion2_w(rank,choose_num,MCmethod,top_k,a,weight);
[new_rank_1,choose_serial_1]=MCMC_fusion_w(rank,choose_num,MCmethod,a,weight);
[new_rank0,choose_serial0]=MCMC_fusion2(rank,choose_num,MCmethod,top_k,a);
[new_rank0_1,choose_serial0_1]=MCMC_fusion(rank,choose_num,MCmethod,a);
%}

function [new_rank,choose_serial]=MCMC_fusion2_w(rank,choose_num,MCmethod,top_k,a,weight)
%list_num=size(rank,1)-1;%不同排序
%sort_num=size(rank,2);% 名次
if (nargin<3)
    MCmethod=3;
    a=0.05;
    top_k=9;
    weight=ones(1,size(rank,1)-1); 

elseif (nargin==3)
    a=0.05;
    top_k=9;
    weight=ones(1,size(rank,1)-1); 

elseif (nargin==4)
    a=0.05;
    weight=ones(1,size(rank,1)-1); 
elseif (nargin==5)
    weight=ones(1,size(rank,1)-1); 
end

    
list_num=size(rank,1)-1;%不同排序
sort_num=size(rank,2);% 名次

if top_k+choose_num>sort_num
    top_k=0;
end

involved_sample_serial=[];
for i=2:list_num+1
    for j=1:top_k+choose_num
         tmp=find(rank(i,:)==j);
         if length(tmp)<=top_k  %%WARNING
         involved_sample_serial=[involved_sample_serial,tmp];
         else
         involved_sample_serial=[involved_sample_serial,tmp(1:top_k)];    
         end
    end
end
if isempty(involved_sample_serial)
    se=randperm(sort_num);
    involved_sample_serial=se(1:choose_num);
end
involved_sample_serial1=unique(involved_sample_serial);
rank1=rank(:,involved_sample_serial1);
[new_rank,choose_serial]=MCMC_fusion_w(rank1,choose_num,MCmethod,a,weight);
%[new_rank,choose_serial]=MCMC_fusion(rank,choose_num,MCmethod,a);
