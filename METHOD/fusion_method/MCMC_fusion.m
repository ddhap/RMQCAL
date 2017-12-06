%   rank=[1,3,5,7,9;5,2,1,3,4;5,2,1,3,4;5,2,1,3,4];
%   rank=[1,3,5,7,9;1,2,3,4,5;5,2,1,3,4;2,2,1,4,5];


%{  
rank=[1,2,3,5;1,2,3,4;3,4,1,2;1,4,2,3];
rank=[1,3,5,7,9;5,4,3,2,1;1,2,3,4,5;];
a=0.05;

[new_rank,choose_serial]=MCMC_fusion(rank,4,3,a);

%}

function [new_rank,choose_serial]=MCMC_fusion(rank,choose_num,MCmethod,a)
%list_num=size(rank,1)-1;%不同排序
%sort_num=size(rank,2);% 名次
if (nargin<3)
    MCmethod=3;
    a=0.05;
elseif (nargin==3)
    a=0.05;
end
    



new_rank_name=rank(1,:);

%% 取choose_num 
%{
if choose_num~=sort_num
   pos=cell(1,size(rank,1)-1);
   pos1=[];
   for h=1:size(rank,1)-1;
       pos{1,h}=find(rank(h+1,:)<=choose_num);
       pos1=[pos1,pos{1,h}];
   end
   pos2=unique(pos1);
   rank1=rank(:,pos2);
else
   rank1=rank;
end 
%}
rank1=rank;

%%开始mcmc

sort_num1=size(rank1,2);  %S
list_num1=size(rank1,1)-1;%L
block_sort=zeros(sort_num1,sort_num1);

for i=1:sort_num1
    for j=1:sort_num1
        if i==j
            block_sort(i,j)=nan;
        else
            th=count_list(rank1,i,j);
            switch MCmethod
                case 1
                if th>0
                block_sort(i,j)=1/sort_num1;
                else
                block_sort(i,j)=0;
                end
                    
                case 2
                    
                if th>floor(list_num1/2)
                block_sort(i,j)=1/sort_num1;
                else
                block_sort(i,j)=0;
                end 
                
                case 3
                    
                block_sort(i,j)=th/sort_num1/list_num1;
            end
        end
    end
end

for i=1:sort_num1
    line=block_sort(i,:);
    pos_not_nan=find(isnan(block_sort(i,:))==0);
    if isempty(pos_not_nan)~=1
    block_sort(i,i)=1-sum(line(1,pos_not_nan));
    end
end
%% 求a
block=nan(sort_num1,sort_num1);
for i=1:sort_num1
    for j=1:sort_num1
        block(i,j)=block_sort(i,j)*(1-a)+a/sort_num1;
    end
end
[~,bb,cc]=eig(block);
[~,pp2]=find(bb==max(max(bb)));
score=-1*abs(cc(:,pp2))';
 
[~,P2]=sort(score);
list=rank1(1,P2);

new_rank=zeros(1,size(score,2));
for i=1:size(score,2)
       new_rank(1,P2(i))=i; 
end       
new_rank=[new_rank_name;new_rank];
choose_serial=new_rank_name(P2(1:choose_num));




function th=count_list(rank,u,v)
list_num=size(rank,1)-1;
rank1=rank(2:list_num+1,:);
th=0;
for i=1:size(rank1,1)
    if rank1(i,u)>rank1(i,v)
       th=th+1;
    end
end

    
    
    
        
        