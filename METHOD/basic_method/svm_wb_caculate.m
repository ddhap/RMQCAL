%http://blog.csdn.net/piaomiaoju/article/details/11659221

function [w,b]=svm_wb_caculate(net)
if length(net.Label)==1
w =1;
b =1;


elseif length(net.Label)==2
w = net.SVs' * net.sv_coef;
b = -net.rho;

%if model.Label(1) == -1
 % w = -w;
%  b = -b;
%end
elseif length(net.Label)>2
   
Label= net.Label;
Label_num=length(Label); 
classification_num=Label_num*(Label_num-1)/2;
classification_num_save=nan(classification_num,2);
xu=1;
for i=1:Label_num-1
    for j=i+1:Label_num
       classification_num_save(xu,1)=Label(i);
       classification_num_save(xu,2)=Label(j);
       xu=xu+1;
    end
end


pos=cell(length(net.Label),length(net.Label)-1);
for i=1:length(net.Label)
    Label_other=Label';
    Label_other(Label_other==i)=[];
    Label_other=Label_other';
    for j=1:(length(net.Label)-1)
        pos{i,j}=sort([Label(i,1),Label_other(j,1)]);
    end
end
position=nan(2,2,classification_num);

for i=1:classification_num
    lv=1;
    for ii=1:length(net.Label)
        for iii=1:length(net.Label)-1
            if isequal(classification_num_save(i,:),pos{ii,iii})==1
               position(lv,:,i)=[ii,iii];
               lv=lv+1;
            end
        end
    end
end
w=nan(1,classification_num);
b=nan(1,classification_num);
number=net.nSV;
number_x=nan(length(number)+1,1);
number_x(1,1)=1;
for i=2:(length(number)+1)
   number_x(i,1)=1+sum(number(1:i-1,1));
end

for i=1:classification_num
    p1pos1=position(1,1,classification_num);
    p1pos2=position(1,2,classification_num);
    p2pos1=position(2,1,classification_num);
    p2pos2=position(2,2,classification_num);
    
    coef = [net.sv_coef(number_x(p1pos1):(number_x(p1pos1+1)-1),p1pos2);net.sv_coef(number_x(p2pos1):(number_x(p2pos1+1)-1),p2pos2)];
    SVs = [net.SVs(number_x(p1pos1):(number_x(p1pos1+1)-1),:);net.SVs(number_x(p2pos1):(number_x(p2pos1+1)-1),:)];
    w(1,i) = SVs'*coef;
    b(1,i) = -net.rho(i);
    
end


    
    
end

%end