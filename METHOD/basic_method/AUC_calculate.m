function auc = AUC_calculate(deci,label_y,net)%%deci=wx+b, label_y, true label

%
%
        Label_tmp=net.Label;
     if length(Label_tmp)~=2&&length(Label_tmp)~=1
        errordlg('can not calculate');
        auc=[];
        return
     end
     label_y1=label_y;
     Label=[1;-1];
     for j=1:length(label_y)
         if label_y1(j)==Label_tmp(1)
            label_y(j)=Label(1);
         else
            label_y(j)=Label(2);
         end
     end
     
%Label
%k=(Label(2)-Label(1))/(Label_tmp(2)-Label_tmp(1));

%b=Label(2)-Label_tmp(2)*k;
%deci=deci*k+b;
deci=deci*Label(1);



    [val,ind] = sort(deci,'descend');

    roc_y = label_y(ind);

    stack_x = cumsum(roc_y == -1)/(sum(roc_y == -1));

    stack_y = cumsum(roc_y == 1)/(sum(roc_y == 1));
    auc = sum((stack_x(2:length(roc_y),1)-stack_x(1:length(roc_y)-1,1)).*stack_y(2:length(roc_y),1));

end