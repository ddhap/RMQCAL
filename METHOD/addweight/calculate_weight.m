
%{
load('matlab.mat');
score=score_tmp;
AL_type=[1,1,1,1,4,3,3,1,1,1,2,2,1,1]';
choose_num=1;
method=1;
[weight] = calculate_weight(score,choose_num,AL_type,method);
%}
function [weight] = calculate_weight(score,choose_num,AL_type,method)
     
weight_tmp=nan(size(score,1),1);
strategy_num=size(score,1);
sample_num=size(score,2);
if size(score,2)<=choose_num||method==0
   weight=ones(strategy_num,1)/strategy_num;
else
   pos2=find(AL_type==2);
   score1=score(setdiff(1:strategy_num,pos2),:);
   score2=score(pos2,:);
   
   weight_score1=nan(size(score1,1),1);
   for i=1:size(score1,1)
       TMP=score1(i,choose_num)-score1(i,sample_num);
       if TMP~=0
       weight_score1(i,1)=(score1(i,choose_num)-score1(i,choose_num+1))./TMP;
       else
       weight_score1(i,1)=0;  
       end
   end
   if sum(weight_score1)==0
      weight_score1=ones(size(score1,1),1);
   end
        
   
   weight_score2=nan(size(score2,1),1); 
   for i=1:size(score2,1)
       weight_score2(i,1)=length(find(score2(i,:)==score2(i,choose_num)));    
   end
   if sum(weight_score2)==0
     weight_score2=ones(size(score2,1),1);
   end      
         
   w1=size(score1,1)/size(score,1);
   w2=size(score2,1)/size(score,1);
       
   ww1=weight_score1*w1/sum(weight_score1);
   ww2=weight_score2*w2/sum(weight_score2);
   weight_tmp(setdiff(1:strategy_num,pos2),1)=ww1;
   weight_tmp(pos2,1)=ww2;
   weight=weight_tmp;
end
   

     
     
     
     
     
%{
%% 类型1： pool based
pos1=find(strategy_type==1);
if isempty(pos1)~=1
score_tmp=scoref(pos1,:);
      if method==0
      weight_tmp(pos1,1)=strategy_type_weight/length(pos1);
      end

end

%% 类型2： stream based
pos2=find(strategy_type==2);
if isempty(pos2)~=1
score_tmp=scoref(pos2,:);
      if method==0
      end
    

end



%% 类型2： early stage based
pos3=find(strategy_type==3);
if isempty(pos3)~=1
weight_tmp(pos3,1)=strategy_type_weight/length(pos3);
end



%% 类型2： entropy based
pos4=find(strategy_type==4);
if isempty(pos4)~=1
score_tmp=scoref(pos4,:);
       if method==0
       end
       
           
weight_tmp(pos4,1)=strategy_type_weight/length(pos4);
end

end










for ii=1:size(scoref,1)
list=scoref(ii,:);
switch method
case 0   % mean
    weight_tmp(ii,1)=1;
case 1   % BVSB
     B=list(1,choose_num);
     if B==min(list)
        weight_tmp(ii,1)=0;
     else
        choose_num1=choose_num+1;
        SB=list(1,choose_num1);
        while(SB==B)
          choose_num1=choose_num1+1;
          SB=list(1,choose_num1);
        end
        weight_tmp(ii,1)=B-SB;
     end
 case 2 % 
     list=scoref(ii,:);
     weight_tmp(ii,1)=sum(list(1:choose_num,1))/(sum(list));
end
end
        
weight=weight_tmp/(sum(weight_tmp));        








end

%}