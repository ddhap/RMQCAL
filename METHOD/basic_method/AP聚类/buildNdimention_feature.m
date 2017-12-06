%http://www.psi.toronto.edu/affinitypropagation/faq.html
%http://wenku.baidu.com/link?url=T9NfGYS8l6Wv0759I0Ck1esl1NqxUFvY5oHuSRENACam66qZ58eZK-efHLN4_Qnhg0pPGAbc67iWSSI0hGG-rDw-J7IqxMgMJUhTxmTLOfW
%N=样本数,dimention=维度数 当dimention=3或2才能绘制,display=1 显示,display=0 不显示
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