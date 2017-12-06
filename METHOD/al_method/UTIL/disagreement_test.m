function disagreement_level=disagreement_test(result,method)

[sample_num,committee_num]=size(result);
disagreement_level=nan(sample_num,1);

if method==0%%方差
   for i=1:sample_num
       one_sample_result=result(i,:);%保证1,2与1,3一致
       one_sample_result_num=length(unique(one_sample_result));
       one_sample_result_serials=sort(unique(one_sample_result));
       one_sample_result_object=1:one_sample_result_num;
       one_sample_result_new=nan(1,size(one_sample_result,2));
       for j=1:size(one_sample_result,2)
          one_sample_result_new(1,j)=one_sample_result_object(1,one_sample_result_serials==(one_sample_result(1,j)));
       end
       disagreement_level(i,1)=var(one_sample_result_new)*-1;
   end
elseif method==1 %% entropy
    for i=1:sample_num
       one_sample_result=result(i,:);%保证1,2与1,3一致 
       one_sample_result_content=unique(one_sample_result);
       one_sample_result_num=length(unique(one_sample_result));
       c=committee_num;
       tmp=nan(1,one_sample_result_num);
       for j=1:one_sample_result_num
           vy=length(find(one_sample_result==one_sample_result_content(j)));
           tmp(1,j)=vy/c*log(vy/c)/log(2);
       end
       disagreement_level(i,1)=sum(tmp);
    end
end

       
    
    
    