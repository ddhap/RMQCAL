function  decision=isarraywell(array,len,max_value,min_value)

        if isempty(array)==1||length(array)~=len||fix(array)~=array||min(array)<min_value||max(array)>max_value
           decision=0;
        else
           decision=1;
        end

          
