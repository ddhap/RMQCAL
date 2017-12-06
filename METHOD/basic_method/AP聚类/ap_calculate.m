%http://www.psi.toronto.edu/affinitypropagation/faq.html
%http://wenku.baidu.com/link?url=T9NfGYS8l6Wv0759I0Ck1esl1NqxUFvY5oHuSRENACam66qZ58eZK-efHLN4_Qnhg0pPGAbc67iWSSI0hGG-rDw-J7IqxMgMJUhTxmTLOfW
%zt=原始特征数据每一行一个样本，一列一个特征
%preference=越大分类数目越少
%method=1无sparse,method=0 sparse
%lam==（阻尼系数）值越小时，迭代次数会减少，但是迭代过程中net Similarity值波动会很大，当要聚类的数据点比较大时，这样难于收敛。当?值较大时，迭代次数会增加，但是总的net Similarity比较平稳
%display1=1画曲线，=0不画
%idx=ap_calculate(zt,1,1,[],1);
function idx=ap_calculate(zt,preference,method,lam,display1)

if isempty(lam)==1||lam<0.5||lam>=1
    errordlg('lam value is not available,so using default');
    lam=0.9;
end
N=size(zt,1);
M=N*N-N; s=zeros(M,3); j=1;
for i=1:N
  for k=[1:i-1,i+1:N]
    s(j,1)=i; s(j,2)=k; s(j,3)=-sum((zt(i,:)-zt(k,:)).^2);
    j=j+1;
  end; 
end;
p=median(s(:,3))*preference; 

if display1==1
   if method==1 
   [idx,netsim,dpsim,expref]=apcluster(s,p,'plot','dampfact',lam);
   else
   [idx,netsim,dpsim,expref]=apclusterSparse(s,p,'plot','dampfact',lam);
   end
elseif display1==0
   if method==1 
   [idx,netsim,dpsim,expref]=apcluster(s,p,'dampfact',lam);
   else
   [idx,netsim,dpsim,expref]=apclusterSparse(s,p,'dampfact',lam);
   end
end
fprintf('Number of clusters: %d\n',length(unique(idx)));
fprintf('Fitness (net similarity): %g\n',netsim);

