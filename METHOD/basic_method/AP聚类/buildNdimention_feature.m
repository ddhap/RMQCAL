%http://www.psi.toronto.edu/affinitypropagation/faq.html
%http://wenku.baidu.com/link?url=T9NfGYS8l6Wv0759I0Ck1esl1NqxUFvY5oHuSRENACam66qZ58eZK-efHLN4_Qnhg0pPGAbc67iWSSI0hGG-rDw-J7IqxMgMJUhTxmTLOfW
%N=������,dimention=ά���� ��dimention=3��2���ܻ���,display=1 ��ʾ,display=0 ����ʾ
%zt=buildNdimention_feature(30,1,1);
function zt=buildNdimention_feature(N,dimention,display)
zt=rand(N,dimention);
 if display==1
   if dimention==2
       figure;
   plot(zt(:,1),zt(:,2),'o');
   elseif dimention==3
       figure;
       plot3(zt(:,1),zt(:,2),zt(:,3),'o');
   elseif dimention==1
       figure;
       plot(zt(:,1),zeros(length(zt),1),'o');
   else
       error('only 2D or 3D');
   end
 end