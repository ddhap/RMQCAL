


%options_active(1)表示每次选择几个

%{
load('zhuyan.mat')
m=train;
now_part_train_sample_ind1=1:100;
rest_part_train_sample_ind1=101:size(m,1);

options=[];train_way=[];
options_active(1,1)=2;%选择数目
options_active(1,2)=0;%随机（只用三个）或 随机用6个或不随机（根据矩阵设定）
options_active(1,3)=1;%=1时为方差法
array_active=[3,0,0,1,1;3,1,0,1,1;3,2,0,1,1;3,3,0,1,1];
 [choose_part_serials,difference_serials_pos]=committee_active_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,train_way,options,options_active,array_active);
%}
function  [choose_part_serials,difference_serials_pos]=committee_active_choose_sample(m,now_part_train_sample_ind1,rest_part_train_sample_ind1,train_way,options,options_active,array_active)
%uncertainty_active_choose_sample 此处显示有关此函数的摘要
%   此处显示详细说明
%%
input_options_active_num=3;
default_options_active=[1,0,1];

if length(options_active) < input_options_active_num, %如果用户给的options_active数少于input_options_active_num个那么其他用默认值; 
  tmp = default_options_active; 
  tmp(1:length(options_active)) = options_active; 
  options_active = tmp; 
end 
%%




now_part_train_sample1=m(now_part_train_sample_ind1,:);
rest_part_train_sample1=m(rest_part_train_sample_ind1,:);

now_classify_type=3;
choose_size=options_active(1);
random_define=options_active(2);
if length(options_active)<3
vote_way=1;
else
vote_way=options_active(3);
end

if choose_size>size(rest_part_train_sample1,1)
   errordlg('choose sample number too much');
   return
else
       if random_define==0
       committee_num=3;
       test_result_matrix=nan(size(rest_part_train_sample1,1),committee_num);
         for i=1:committee_num
         options=[];
         [~,~,~,test_result_matrix(:,i),~] = active_train(now_part_train_sample1,rest_part_train_sample1,i,options);
         end
       elseif random_define==1  
           committee_num=6;
           test_result_matrix=nan(size(rest_part_train_sample1,1),committee_num);
           for i=1:2
           options=[];
           [~,~,~,test_result_matrix(:,i),~] = active_train(now_part_train_sample1,rest_part_train_sample1,i,options);
           end
           for i=3:6
           [~,~,~,test_result_matrix(:,i),~] = active_train(now_part_train_sample1,rest_part_train_sample1,3,i-3);
           end 
       else
                    committee_num=size(array_active,1);
          if  max(array_active(:,1))>now_classify_type||min(array_active(:,1))<1||size(array_active,2)~=5||isequal(array_active(:,1),fix(array_active(:,1)))~=1         
              errordlg('输入委员参数array_active有误');
              return
          else
          
                    test_result_matrix=nan(size(rest_part_train_sample1,1),committee_num);
                    for i=1:committee_num
                    train_way=array_active(i,1);
                    options_tmp=array_active(i,2:5);
                    nan_pos=find(isnan(options_tmp)==1);
                    if isempty(nan_pos)==1
                    options=options_tmp;
                    else    
                    options=options_tmp(1,1:(nan_pos(1)-1));
                    end
                  %{
                     %选择分类器类型
                     %input=3.14159;
                     %while((input<1)||(input>now_classify_type)||(fix(input)~=input))
                     %input_tmp=inputdlg(['输入分类类型1bays2bp3svm，第',num2str(i),'个委员']);
                     %input_tmp_c=cell2mat(input_tmp);
                     %   if isempty(input_tmp_c)==1
                     %   input_tmp_c='3.14159';
                     %   end
                     % input=str2num(input_tmp_c);
                     % end
                     
                   %%
                     word=['bays','bp','svm'];
                     options_tmp=inputdlg(['第',num2str(i),'个委员',word(i),'的option，四个参数用,分开']);
                     if isempty(cell2mat(options_tmp))==1
                     options=[];
                     else
                     eval(['options_tmp1=[',options_tmp,']']);
                     if size(options_tmp1,2)==4&&size(options_tmp1,1)==1
                     options=options_tmp1;  
                     else
                     errordlg('输入有误，切换默认');
                     options=[];
                     end
                     end
                    
                  %}
                    [~,~,~,test_result_matrix(:,i),~] = active_train(now_part_train_sample1,rest_part_train_sample1,train_way,options);
                    end
          end
           
        end
 end
 [choose_part_serials,difference_serials_pos]=committee_vote_choose_way(test_result_matrix,vote_way,choose_size);