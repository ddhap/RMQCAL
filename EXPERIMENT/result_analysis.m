


%{
label_stand=test_sample(:,2);
label_type=sort(unique(label_stand));
positive_class=label_type(1);
test_result_block=result.al_performance.test_result_block;
[confusion_table_test,accuracy1,precision1,recall1,fp1,F1measure]=result_analysis(test_result_block,label_stand,positive_class);



%}




function [confusion_table_test,accuracy1,precision1,recall1,fp1,F1measure]=result_analysis(test_result_block,label_stand,positive_class)
confusion_table_test=nan(2,2,size(test_result_block,2));
accuracy1=nan(1,size(test_result_block,2));
precision1=nan(1,size(test_result_block,2));
recall1=nan(1,size(test_result_block,2));
fp1=nan(1,size(test_result_block,2));
F1measure=nan(1,size(test_result_block,2));
H=waitbar(0,'开始制作混淆表');
for i=1:size(test_result_block,2)
    [confusion_table_test(:,:,i),accuracy1(1,i),precision1(1,i),recall1(1,i),fp1(1,i),F1measure(1,i)] = confusion_table_make(test_result_block(:,i),label_stand,positive_class);
    waitbar(i/size(test_result_block,2),H,['已制作混淆表',num2str(i),'个共',num2str(size(test_result_block,2)),'组']);
end



delete(H);   


