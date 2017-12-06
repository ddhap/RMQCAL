function [choose_part_serials,difference_serials_pos]=committee_vote_choose_way(test_result_matrix,vote_way,choose_size)
[sample_num,~]=size(test_result_matrix);

difference_serials=nan(sample_num,1);

    switch vote_way
    case 1%·½²î·¨
    for i=1:sample_num
    one_sample_result=test_result_matrix(i,:);
        one_sample_result_num=length(unique(one_sample_result));
        one_sample_result_serials=sort(unique(one_sample_result));
        one_sample_result_object=1:one_sample_result_num;
        one_sample_result_new=nan(1,size(one_sample_result,2));
          for j=1:size(one_sample_result,2)
          one_sample_result_new(1,j)=one_sample_result_object(1,one_sample_result_serials==(one_sample_result(1,j)));
          end
       difference_serials(i,1)=var(one_sample_result_new);
    end
       [~,difference_serials_pos]=sort(difference_serials,'descend');
       choose_part_serials=difference_serials_pos(1:choose_size,1);
    case 2%\
    
    end


