%http://wenku.baidu.com/link?url=RxLY2hALK8LScoiaHd2L4Vyz0MJtDwaHcrRodnIb_mnpuE8PycTQ0u9BrtxMpFcEHpykRzVnRRuz_xLq8ZJECE3CGYHn0U4MB1XZ8HfWRHy
%http://blog.csdn.net/t710smgtwoshima/article/details/8215037
%Accuracy=accuracy��ȷ��
%Sensitivity=recall�������ʣ��ٻ���
%false positives����α��Ҳͨ��������
%��������(false positive rate, FPR),���㹫ʽΪFPR= FP / (FP + TN)��������Ƿ���������Ϊ����ĸ�ʵ��ռ���и�ʵ���ı���������һ���渺���ʣ�True Negative Rate��TNR����Ҳ��Ϊspecificity,���㹫ʽΪTNR=TN/ (FP+ TN) = 1-FPR��
%©���ʣ��ֳƼ�������TNR��False negative rate����ָ���׼ȷ��Ĳ������������Ϊ���Եİٷֱȡ�©����=1-�����ȡ�
%Precision = TP/TP+FP, ������������x���Ԫ������������x���Ԫ���еı�����������ָ��ȷʶ���ʵ�����ռ���б�ʶ��ʵ������ı�������ȷʶ��ĸ���/��ȷʶ��ĸ���+����ʶ��ĸ���
function [table,accuracy,precision,recall,fp,F1measure] = confusion_table_make(label_forecast,label_stand,research_point)%Ԥ�� ʵ��
%confusion_table �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%actual forecast
if length(unique(label_stand))~=2||isempty(find(label_stand==research_point))==1
    errordlg('����������ɶ������о��಻����')
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

    