load('wine_data.mat');
m=data(1:130,:);
choose_num=2;

choose_strategies{1,1}=[2,4];
choose_strategies{1,2}=[2,3,4];
choose_strategies{1,3}=[2,3,4,6];
choose_strategies{1,4}=[2,3,4,12,7];
choose_strategies{1,5}=[2,3,4,12,7,5];
choose_strategies{1,6}=[2,3,4,5,6,7,11];
sample_num=[50,75,100,50,75,100];
block=cell(2,6);
th=100;
for i=1:6
    tmp=nan(th,10);
    tmpa=cell(th,10);
    for j=1:th
    cs=choose_strategies{1,i};
    sn=sample_num(i);
    [serial]=randperm(130);
    now_part_train_sample_ind1=serial(sn+1:end);
    rest_part_train_sample_ind1=serial(1:sn);
    rank_result=1:length(rest_part_train_sample_ind1);
    for ii=1:length(cs)
       [~,~,~,rank_tmp,~]=active_choose_sample(cs(1,ii),m,now_part_train_sample_ind1,rest_part_train_sample_ind1,choose_num);
       rank_result=[rank_result;rank_tmp'];
       disp(['finish ',num2str(i),'th active learning']);
    end
    a=0.05;
    choose_num=2;
    MCmethod=2;
    
    for jj=1:10
    [new_rank_1,choose_serial_1]=MCMC_fusion2(rank_result,2,MCmethod,jj,a);
    [new_rank,choose_serial]=MCMC_fusion(rank_result,2,MCmethod,a);
    error=0;
    for iii=1:2
        pos=find(new_rank(1,:)==choose_serial_1(iii));
        relative_rank=new_rank(2,pos);
        error=error+abs(iii-relative_rank);
    end
    tmp(j,jj)=error;
    tmpa{j,jj}=[choose_serial_1;choose_serial];
    end
    end
    tmp2=mean(tmp);
    block{1,i}=tmp2;
    block{2,i}=tmpa;
       
end



