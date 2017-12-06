%{
num=10;
compare=7;
mat2{1,1}=mean
mat2{1,2}=std

%}

function [mat3,score_block,wlt_block,block_Z,block_R,block_B,block_X]=ttest2_block_invert(mat2,num,compare)
score_block=cell(size(mat2,1),1);
tmp=setdiff(1:size(mat2{1,1},1),compare);
for i=1:size(mat2,1)
score_block{i,1}=ttest2_block(mat2{i,1},mat2{i,2},num,compare);
end
win_block=zeros(size(tmp,2),size(mat2{1,1},2));
lose_block=zeros(size(tmp,2),size(mat2{1,1},2));
tie_block=zeros(size(tmp,2),size(mat2{1,1},2));
for i=1:size(score_block,1)
    for k=1:size(mat2{1,1},2)
        for jj=1:size(tmp,2)
            j=tmp(jj);
            if score_block{i,1}(j,k)==3
               win_block(jj,k)=win_block(jj,k)+1;
            elseif score_block{i,1}(j,k)==1
               tie_block(jj,k)=tie_block(jj,k)+1; 
            elseif score_block{i,1}(j,k)==0
               lose_block(jj,k)=lose_block(jj,k)+1;  
            end 
        end
    end
end
wlt_block.win=win_block;
wlt_block.tie=tie_block;
wlt_block.lose=lose_block;

block=nan(size(tmp,2),size(mat2{1,1},2)*3);
for ii=1:size(wlt_block.win,2)
    block(:,(3*ii-2))=wlt_block.win(:,ii);
    block(:,(3*ii-1))=wlt_block.tie(:,ii);
    block(:,(3*ii))=wlt_block.lose(:,ii);
end
    
block_Z=block;
block_R=[sum(wlt_block.win,2),sum(wlt_block.tie,2),sum(wlt_block.lose,2)];
block_B=sum(block_Z,1);
block_X=sum(block_R,1);

mat3=cell(size(mat2,1),1);
for i=1:size(mat2,1)
    TMP=nan(size(mat2{1,1},1),size(mat2{1,1},2)*2);
    for j=1:size(mat2{i,1},2)
        TMP(:,2*j-1)=mat2{i,1}(:,j);
    end
    for j=1:size(mat2{i,1},2)
        TMP(:,2*j)=mat2{i,2}(:,j);
    end
    mat3{i,1}=TMP;
    
end



