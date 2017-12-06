clc
clear

method_name='ADABOOST';%-P
method_purpose='classification';%-P
para_name={'Iterative_times'};%-P列向量

%%
%———————setting———————
display=1;  %-C  =1 display  =0 not
test_set_size=100;%-C 测试集大小
isvalidate=1;%-C =1进行验证=0不进行验证
%———————load data——————— 
load('class_data.mat', 'data');
if  strcmp(method_purpose,'classification')==1
           purpose=0;
elseif strcmp(method_purpose,'regression')==1
           purpose=1;
else    
           purpose=2;
end
%data  first row is name,second is label other is feature
sample_num=size(data,1);
type=sort(data(:,2));
%feature_num=size(data,2)-2;
[test_set,other_set]=testset_acquire(data,test_set_size);
%———————validation——————— 
if isvalidate==1%进行验证
vaildition_set_size=100;%-C 验证集大小
Iterative_times=1:1:10;%-CP 验证集大小

range.name=method_name;
range.para_name=para_name;


range.para_takingvalue=cell(size(para_name,1),1);
for v=1:size(para_name,1)
    eval(['range.para_takingvalue{v,1}=',para_name{v,1},';']);
end


      if size(range.para_takingvalue,1)~=size(range.para_name,1) 
          errordlg('takingvalue is wrong');
          return
      end

cross_vaildition_set=cross_vailditionset_build(other_set,vaildition_set_size);
range.Ergodic_matrix=Ergodic_matrix_generation(range.para_takingvalue);
option=ADABOOST_VAILDITION(cross_vaildition_set,range,display,purpose);%-P

str=[];
  for k=2:size(option.block_name,1)
        name=option.block_name(k,1);
        str_tmp=[name{1,1} '=' num2str(option.best(k-1,1)),';'];
        str=[str,str_tmp];
  end
  eval(str);

elseif isvalidate==0
%不进行测试—————————————   
Iterative_times=10;%PC迭代次数
option=[];
end

%%
%———————test———————
tr_set=other_set(:,3:end);
tr_labels=other_set(:,2);

t1 = clock;               
adaboost_model = ADABOOST_tr(@threshold_tr,@threshold_te,tr_set,tr_labels,Iterative_times);%P
t2 = clock;
[L_tr,hits] = ADABOOST_te(adaboost_model,@threshold_te,test_set(:,3:end),test_set(:,2));%P
test_result=likelihood2class(L_tr);%P

t3 = clock; 
%———————result———————
 if purpose==0%分类
    classification_error=length(find((test_result-test_set(:,2))~=0))/size(test_set(:,2),1);
    regression_error=nan;
 elseif purpose==1%回归
    regression_error=sum(power((test_result-test_set(:,2)),2));
    classification_error=nan;
 end
   label=test_set(:,2);
   train_usetime=etime(t2,t1);
   test_usetime=etime(t3,t2);
   test_num=size(test_set,1);
   feature_num=size(test_set,2)-2;
   train_num=size(other_set,1);
   RESULT.method_purpose=method_purpose;
   RESULT.label=label;
   RESULT.result=test_result;
   RESULT.regression_error=regression_error;
   RESULT.classification_error=classification_error;
   RESULT.usetime.training=train_usetime;
   RESULT.usetime.test=test_usetime;
   RESULT.number.test=test_num;
   RESULT.number.train=train_num;
   RESULT.number.feature=feature_num;
   RESULT.vaildition=option;
   %------
  str2=[];
  for kk=1:size(para_name,1)
        name=para_name{kk,1};
        str_tmp2=['RESULT.para.',name,'=',name,';'];
        str2=[str2,str_tmp2];
  end
  eval(str2);

   %-----
if display==1
      if purpose==0%分类
      disp(['Test classification_error = ',num2str(classification_error),',training usetime = ',num2str(train_usetime),',test usetime = ',num2str(test_usetime),',train num = ',num2str(train_num),',test num = ',num2str(test_num),',feature num = ',num2str(feature_num)])
      elseif purpose==1%回归
      disp(['Test regression_error = ',num2str(regression_error),',training usetime = ',num2str(train_usetime),',test usetime = ',num2str(test_usetime),',train num = ',num2str(train_num),',test num = ',num2str(test_num),',feature num = ',num2str(feature_num)])
      end
     if isvalidate==1
      vailditionset_draw(RESULT.vaildition);
      end
end