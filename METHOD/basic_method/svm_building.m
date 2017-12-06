
%{
http://baike.baidu.com/link?url=gMbZ7Ig6lmrhSMjaLkDf5EbX_Asn4_4t2HgnMilX8Zo30pOAfuEMd8Vz7Q-e78gkmH6tOp_s0cYOin1sT_4k4K
Train=[[(1:10)',ones(10,1),(1:10)'];[(11:20)',ones(10,1)*2,(11:20)']];
cfhs=2;hhs=1;
[net,need_type,options_out]=svm_building(Train,options)
%}

function [net,need_type,options_out]=svm_building(Train,options)%%ѵ����  ��Ϸ���,SVM���� �ͷ�����  �˺���             
%%�ͷ���˲�������
input_option_num=4;
default_options=[2,0,1,1/(size(Train,2)-2)];
if nargin ==1
options = default_options;
else
if length(options) < input_option_num %����û�����opition������4����ô������Ĭ��ֵ; 
  tmp = default_options; 
  tmp(1:length(options)) = options; 
  options = tmp; 
end 
end
way= options(1);
type=options(2);
cfhs=options(3);
hhs=options(4);

if (any([0,1,2,3]==way)==0)||(any([0,1,2,3,4]==type)==0)||(hhs<0)||(cfhs<0)
errordlg('input parameter wrong');
net=[];
need_type=[];
option_output=[];
else
cfhsandhhs=[' -c ',num2str(cfhs),' -g ',num2str(hhs),' '];
if way==3 %sigmod
   way1=[' -t ',num2str(3)];
elseif way==0  %linear
   way1=[' -t ',num2str(0)];
elseif way==1  %polynomial
   way1=[' -t ',num2str(1)];
elseif way==2  %radial basis function
   way1=[' -t ',num2str(2)];
end

if type==0 % C-SVC
   type1=[' -s ',num2str(0),' '];
elseif type==1  %v-SVC
   type1=[' -s ',num2str(1),' '];
elseif type==2  % һ��SVM
   type1=[' -s ',num2str(2),' '];
elseif type==3  %e -SVR
   type1=[' -s ',num2str(3),' '];
elseif type==3  %v-SVR
   type1=[' -s ',num2str(4),' '];
end
option_output=[' -q ',way1,type1,cfhsandhhs];
net=svmtrain(Train(:,2),Train(:,3:end),option_output);
need_type=sort(unique(Train(:,2)));
end
options_out=options;