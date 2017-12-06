load('Nbreast.mat');
fea=data(:,3:end);
for i=1:size(fea,2)
    m=max(fea(:,i));
    n=min(fea(:,i));
    if m~=n
    fea(:,i)=fea(:,i)/(m-n);
    else
    fea(:,i)=ones(size(fea,1),1)*0.5;
    end
end 
data(:,3:end)=fea;


fea_new = tsne_AL1(data(:,3:end), data(:,2),10,5);