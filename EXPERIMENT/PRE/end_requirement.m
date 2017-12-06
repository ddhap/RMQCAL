function whether_end=end_requirement(train_num,accuray_block,use_label_cost,end_requirement_way,end_requirement_options)
%end_requirement 此处显示有关此函数的摘要
%   此处显示详细说明
%whether_end输出1则停止，0为继续
accuracy_now=accuray_block(1,length(accuray_block));
switch end_requirement_way
case 1
  whether_end=0;
case 2
  if isempty(end_requirement_options)~=1    
  accuracy_stand=end_requirement_options;
  else
  accuracy_stand=1;    
  end
  if accuracy_now<accuracy_stand
      whether_end=0;
  else
      whether_end=1;
  end
case 3
    if isempty(end_requirement_options)~=1    
       batch_limit=end_requirement_options;
    else
       batch_limit=inf;    
    end
    if size(use_label_cost,2)<batch_limit
      whether_end=0;
    else
      whether_end=1;
    end
    
 case 4
    if isempty(end_requirement_options)~=1    
       usenum_limit=end_requirement_options;
    else
       usenum_limit=inf;    
    end
    if max(use_label_cost)<usenum_limit
      whether_end=0;
    else
      whether_end=1;
    end
case 5
    if isempty(end_requirement_options)~=1    
       usenum_per=end_requirement_options;
    else
       usenum_per=1;    
    end
    if max(use_label_cost)<ceil(usenum_per*train_num)
      whether_end=0;
    else
      whether_end=1;
    end    
end

