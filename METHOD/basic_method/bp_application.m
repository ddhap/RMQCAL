function [test_result,diff,need_type]=bp_application(test,net,need_type)%bp应用，diff越接近0越可疑
P_test=test(:,3:end)';
T_sim=sim(net,P_test);
type_num=size(need_type,1);
test_matrix=nan(type_num,length(T_sim));

for i=1:type_num
    for j=1:length(T_sim)
        test_matrix(i,j)=abs(need_type(i,1)-T_sim(1,j));
    end
end
test_result=nan(length(T_sim),1);
firstandnext=nan(3,length(T_sim));
test_matrix_tmp=test_matrix;
for j=1:length(T_sim)
    first=find(test_matrix(:,j)==min(test_matrix(:,j)));
    firstandnext(1,j)=test_matrix(first(1),j);
    test_matrix_tmp(first(1),j)=nan;
    judge=find(test_matrix(:,j)==min(test_matrix(:,j)));
    if length(judge)==1
        test_result(j,1)=need_type(judge);
    else
        test_result(j,1)=nan;
    end
end
for j=1:length(T_sim)
    next=find(test_matrix_tmp(:,j)==min(test_matrix_tmp(:,j)));
    firstandnext(2,j)=test_matrix_tmp(next(1),j);
    firstandnext(3,j)=firstandnext(2,j)-firstandnext(1,j);
end
diff=firstandnext(3,:)';
%diff越大越好区分