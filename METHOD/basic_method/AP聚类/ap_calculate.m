%http://www.psi.toronto.edu/affinitypropagation/faq.html
%http://wenku.baidu.com/link?url=T9NfGYS8l6Wv0759I0Ck1esl1NqxUFvY5oHuSRENACam66qZ58eZK-efHLN4_Qnhg0pPGAbc67iWSSI0hGG-rDw-J7IqxMgMJUhTxmTLOfW
%zt=ԭʼ��������ÿһ��һ��������һ��һ������
%preference=Խ�������ĿԽ��
%method=1��sparse,method=0 sparse
%lam==������ϵ����ֵԽСʱ��������������٣����ǵ���������net Similarityֵ������ܴ󣬵�Ҫ��������ݵ�Ƚϴ�ʱ������������������?ֵ�ϴ�ʱ���������������ӣ������ܵ�net Similarity�Ƚ�ƽ��
%display1=1�����ߣ�=0����
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

