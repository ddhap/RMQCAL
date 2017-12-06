%http://wenku.baidu.com/link?url=RxLY2hALK8LScoiaHd2L4Vyz0MJtDwaHcrRodnIb_mnpuE8PycTQ0u9BrtxMpFcEHpykRzVnRRuz_xLq8ZJECE3CGYHn0U4MB1XZ8HfWRHy
%http://blog.csdn.net/t710smgtwoshima/article/details/8215037
%Accuracy=accuracy正确率
%Sensitivity=recall真阳性率，召回率
%false positives（纳伪）也通常称作误报
%负正类率(false positive rate, FPR),计算公式为FPR= FP / (FP + TN)，计算的是分类器错认为正类的负实例占所有负实例的比例。还有一个真负类率（True Negative Rate，TNR），也称为specificity,计算公式为TNR=TN/ (FP+ TN) = 1-FPR。
%漏诊率，又称假阴性率TNR（False negative rate），指金标准确诊的病例被试验错判为阴性的百分比。漏诊率=1-灵敏度。
%Precision = TP/TP+FP, 精度是真属于x类的元素在所有属于x类的元素中的比例。精度是指正确识别的实体个数占所有被识别实体个数的比例。正确识别的个数/正确识别的个数+错误识别的个数
function [table,accuracy,precision,recall,fp,F1measure] = confusion_table_make(label_forecast,label_stand,research_point)%预测 实际
%confusion_table 此处显示有关此函数的摘要
%   此处显示详细说明
%actual forecast
if length(unique(label_stand))~=2||isempty(find(label_stand==research_point))==1
    errordlg('程序仅能生成二类表或研究类不存在')
    table=[];accuracy=[];precision=[];recall=[];fp=[];
else
    
    type=sort(unique(label_stand));
    First_class= type(1);
    Second_class=type(2);
    A1=find(label_stand==First_class);
    A2=find(label_stand==Second_class);
    F1=find(label_forecast==First_class);
    F2=find(label_forecast==Second_class);
    A1F1=size(intersect(A1,F1),1);%tp tn
    A1F2=size(intersect(A1,F2),1);%fn fp
    A2F1=size(intersect(A2,F1),1);%fp fn
    A2F2=size(intersect(A2,F2),1);%tn tp
    table=[A1F1,A1F2;A2F1,A2F2];
    accuracy=(A1F1+A2F2)/(A1F1+A1F2+A2F1+A2F2);
    if research_point==First_class
        if A2F1+A2F2==0
        fp=0;
        else
        fp=(A2F1)/(A2F1+A2F2);
        end
        
        if A1F1+A2F1==0
        precision=1;
        else
        precision=A1F1/(A1F1+A2F1);
        end
        
        if A1F1+A1F2==0
        recall=1;
        else
        recall=A1F1/(A1F1+A1F2);
        end
        
        
    elseif research_point==Second_class
        
        if A1F1+A1F2==0
        fp=0;
        else
        fp=(A1F2)/(A1F1+A1F2);
        end
        
        if A2F2+A1F2==0
        precision=1;
        else
        precision=A2F2/(A2F2+A1F2);
        end
        
        if A2F2+A2F1==0
        recall=1;
        else
        recall=A2F2/(A2F2+A2F1);
        end
    end
    
    F1measure=2*recall*precision/(recall+precision);
    
end

    