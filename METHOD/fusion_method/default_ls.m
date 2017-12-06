matrix=rand(100,100);
hehe=1./sum(matrix');
matrix1=nan(size(matrix,1),size(matrix,2));
for i=1:length(hehe)
    matrix1(i,:)=matrix(i,:)*hehe(i);
end
num=10;
list=nan(num,size(matrix1,2));
for i=1:num
    mat=matrix1^i;
    [p,q]=sort(sum(mat));
    list(i,:)=q;
end
[u1,u2]=eig(mat);
[w1,w2]=eig(mat);