load('Nbreast.mat');
fea_S=6;
batch_size=50;
fea=data(:,fea_S);
max_fea=max(fea);
min_fea=min(fea);
tmp=(max_fea-min_fea)/(batch_size-2);
tmp2=(1:batch_size)-2;
b=nan(1,batch_size);
for i=1:batch_size
    b(1,i)=tmp2(i)*tmp+min_fea;
end
hist(fea,b);
