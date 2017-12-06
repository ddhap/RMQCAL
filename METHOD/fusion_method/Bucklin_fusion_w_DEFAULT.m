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










function [new_rank,choose_serial]=Bucklin_fusion_w_DEFAULT(rank,choose_num,weight)

if size(weight,2)==1
   weight=weight';
elseif size(weight,2)~=1&&size(weight,1)~=1
   weight=ones(1,size(rank,1)-1);   
elseif size(weight,2)~=size(rank,1)-1&&size(weight,1)~=size(rank,1)-1
   weight=ones(1,size(rank,1)-1);  

end
stand=ceil(sum(weight)/2);
new_rank_name=rank(1,:);
rank_tmp=rank(2:end,:);
sample_num=size(rank_tmp,2);
rank_num=size(rank_tmp,1);
rank_new=zeros(1,sample_num);% 每一个名字的排名

i=1;
while(isempty(find(rank_new==0))==0)  %每个名次
    sample_num=size(rank_tmp,2);
    statistic_block_line=zeros(1,sample_num);
    statistic_block=zeros(1,sample_num);

    start_v=i;
    for ii=1:rank_num
      pos=find(rank_tmp(ii,:)<=start_v);
      statistic_block_line(1,pos)=statistic_block_line(1,pos)+weight(1,ii);
    end
    statistic_block=statistic_block_line;
    
    pos1=find(sum(statistic_block,1)>stand);
    
    while(isempty(pos1)==1)
    start_v=start_v+1;
    statistic_block_line=zeros(1,sample_num);
    for ii=1:rank_num
      pos=find(rank_tmp(ii,:)==start_v);
      statistic_block_line(1,pos)=statistic_block_line(1,pos)+weight(1,ii);
    end
    statistic_block=[statistic_block;statistic_block_line];
    pos1=find(sum(statistic_block,1)>stand);
    end
    
    candidit=rank_tmp(:,pos1);
    candidit_min=min(candidit);
    pos2=find(candidit_min==min(candidit_min));
    rank_new(1,pos1(pos2))=i;
    i=i+length(pos2);
    for iii=1:size(pos2,2)
    rank_tmp(:,pos1(pos2(iii)))=ones(rank_num,1)*99999;
    end
end
new_rank=[new_rank_name;rank_new];

[~,rank_new]=sort(rank_new);

choose_serial=new_rank_name(rank_new(1:choose_num));

