function [all_choose,serial,choose_mat]=random_choose(m,ind,choose_num,way)
mat=m(ind,:);
matrix_num=size(mat,1);
if way==1%完全随机取
sj=randperm(matrix_num);    
all_choose=sj(1,1:choose_num);
serial=sj';

choose_mat=mat(all_choose,:);

elseif way==2%尽可能平均取2
    matrix_label=unique(sort(mat(:,2)));
    matrix_label_num=length(matrix_label);
    every_label_sample_num=zeros(1,matrix_label_num);
    every_label_sample_serial=cell(1,matrix_label_num);
     every_label_sample_serial_re=cell(1,matrix_label_num);
    for i=1:matrix_label_num
      every_label_sample_num(1,i)=length(find(mat(:,2)==matrix_label(i)));
      every_label_sample_serial{1,i}=find(mat(:,2)==matrix_label(i));
      every_label_sample_serial_re{1,i}=every_label_sample_serial{1,i}(randperm(every_label_sample_num(1,i)),1);
    end
   tmp=zeros(max(every_label_sample_num),matrix_label_num);
   for i=1:matrix_label_num
       tmp(1:every_label_sample_num(1,i),i)=every_label_sample_serial_re{1,i};
   end
   serial_including_zero=[];
   for i=1:max(every_label_sample_num)
       tmp1=tmp(i,:);
       tmp2=tmp1(:,randperm(matrix_label_num));
       serial_including_zero=[serial_including_zero,tmp2];
   end
     serial_unincluding=serial_including_zero;
     serial_unincluding(find(serial_unincluding==0))=[];
     all_choose=serial_unincluding(1:choose_num);
     serial=serial_unincluding';
     choose_mat=mat(all_choose,:);  
end
 