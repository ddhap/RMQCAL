%{
need_label_serial=[2,5,7,9,4,3,6,8]

sv_indices=[1,10,3,8,4,7];

%}

function map_score=MAP_calculation(need_label_serial,sv_indices)
           tmp=intersect(need_label_serial,sv_indices');
           pos=nan(1,length(tmp));
           for i=1:length(tmp)
               pos(1,i)=find(need_label_serial==tmp(i));
           end
           pos_score=sort(pos,'ascend');
           sum_score=0;
           for i=1:length(pos_score)
               sum_score=sum_score+i/pos_score(1,i);
           end
           map_score=sum_score/length(pos_score);
               
               

         