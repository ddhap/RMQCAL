%http://www.psi.toronto.edu/affinitypropagation/faq.html
%http://blog.sina.com.cn/s/blog_6f611c3001019jlf.html
%http://wenku.baidu.com/link?url=T9NfGYS8l6Wv0759I0Ck1esl1NqxUFvY5oHuSRENACam66qZ58eZK-efHLN4_Qnhg0pPGAbc67iWSSI0hGG-rDw-J7IqxMgMJUhTxmTLOfW
%center_num=中心点数,around_num=周围点数 display=1 显示,display=0 不显示
%zt=build2dimention_feature(5,10,1);
function zt=build2dimention_feature(center_num,around_num,display)
x_o=rand(1,center_num)*10;y_o=rand(1,center_num)*10;
x=[];
y=[];

for j=1:center_num
for i=1:around_num
    x_add=rand(1,1)-0.5;
    y_add=rand(1,1)-0.5;
    x_l=x_o(1,j)+x_add;
    y_l=y_o(1,j)+y_add;
    x=[x,x_l];
    y=[y,y_l];
end
end

zt=[x',y'];
 if display==1
 figure
 plot(zt(:,1),zt(:,2),'o');
 end
