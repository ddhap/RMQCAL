
%{
clc
clear
A=[1,nan,-inf,inf;2,inf,4,nan;3,4,5,nan;nan,1,inf,-inf];;
 label=[1,2,2,nan]';
 name=[0001,0002,0003,0004]';
 matrix=[name,label,A];
%}
function  matrix_new=initialization_matrix(matrix)
[M,N]=size(matrix);
sample_num=M;
feature_num=N-2;
name=matrix(:,1);
label=matrix(:,2);
feature=matrix(:,3:end);
label_un=unique(label);
categories_num=length(label_un);
%%总样本统计
sample_mean=nan(1,feature_num);
for j=1:feature_num
    feature_one=feature(:,j);
    f1=find(feature_one~=inf);f2=find(~isnan(feature_one));f3=find(feature_one~=-inf);
    correct_seat=intersect(intersect(f1,f2),f3);
    if  isempty(correct_seat)==1
    sample_mean(1,j)=0;    
    else
    sample_mean(1,j)=mean(feature_one(correct_seat,1));
    end
end
sample_one_mean=nan(categories_num,feature_num); 
for i=1:categories_num%每一类
   if isnan(label_un(i,1))~=1
   label_seat=find(label==label_un(i,1));
   else
   label_seat=find(isnan(label));
   end

        for j=1:feature_num
            feature_one_one=feature(label_seat,j);
            f1=find(feature_one_one~=inf);f2=find(~isnan(feature_one_one));f3=find(feature_one_one~=-inf);
            correct_seat1=intersect(intersect(f1,f2),f3);
            wrong_seat1=setdiff(1:size(feature_one_one,1),correct_seat1);
            if  isempty(correct_seat1)==1||isnan(label_un(i,1))==1
            sample_one_mean(i,j)=sample_mean(1,j);
            else
            sample_one_mean(i,j)=mean(feature_one_one(correct_seat1,1));
            end
        end
  
end

feature_new=feature;
      for i=1:sample_num
          for j=1:feature_num
              if feature(i,j)==inf||feature(i,j)==-inf||isnan(feature(i,j))==1   
                  if isnan(label(i,1))==1
                      feature_new(i,j)=sample_one_mean(isnan(label_un),j);
                  else
                      feature_new(i,j)=sample_one_mean(label_un==label(i,1),j);
                  end
              end
          end
      end
matrix_new=[name,label,feature_new];

