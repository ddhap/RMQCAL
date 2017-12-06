clc
clear
zt=buildNdimention_feature(50,2,0);
subplot(3,3,1); preference=0.1;idx=ap_calculate(zt,preference,0,0.9,0); h=ap_draw(zt,idx);title(['sparse方法,preference=',num2str(preference)]);
subplot(3,3,2); preference=0.5;idx=ap_calculate(zt,preference,0,0.9,0); h=ap_draw(zt,idx);title(['sparse方法,preference=',num2str(preference)]);
subplot(3,3,3); preference=1;idx=ap_calculate(zt,preference,0,0.9,0); h=ap_draw(zt,idx);title(['sparse方法,preference=',num2str(preference)]);
subplot(3,3,4); preference=5;idx=ap_calculate(zt,preference,0,0.9,0); h=ap_draw(zt,idx);title(['sparse方法,preference=',num2str(preference)]);
subplot(3,3,5); h=plot(zt(:,1),zt(:,2),'o');title('原始图像');
subplot(3,3,6); preference=0.1;idx=ap_calculate(zt,preference,1,0.9,0); h=ap_draw(zt,idx);title(['传统方法,preference=',num2str(preference)]);
subplot(3,3,7); preference=0.5;idx=ap_calculate(zt,preference,1,0.9,0); h=ap_draw(zt,idx);title(['传统方法,preference=',num2str(preference)]);
subplot(3,3,8); preference=1;idx=ap_calculate(zt,preference,1,0.9,0); h=ap_draw(zt,idx);title(['传统方法,preference=',num2str(preference)]);
subplot(3,3,9); preference=5;idx=ap_calculate(zt,preference,1,0.9,0); h=ap_draw(zt,idx);title(['传统方法,preference=',num2str(preference)]);