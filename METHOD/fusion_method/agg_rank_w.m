 %{
rank=[1,3,5,7,9;5,2,1,3,4;5,2,1,3,4;5,2,1,3,4];
method=2;
choose_num=4;
option_agg=[];
weight=[1,1,1];
[new_rank,choose_serial]=agg_rank_w(method,rank,choose_num,weight,option_agg);
[new_rank,choose_serial]=agg_rank(method,rank,choose_num,option_agg);
%}

function [new_rank,choose_serial]=agg_rank_w(method,rank,choose_num,weight,option_agg)
if size(weight,2)==1
   weight=weight';
elseif size(weight,2)~=1&&size(weight,1)~=1
   weight=ones(1,size(rank,1)-1);   
elseif size(weight,2)~=size(rank,1)-1&&size(weight,1)~=size(rank,1)-1
   weight=ones(1,size(rank,1)-1);  

end
switch method


    case 1
[new_rank,choose_serial]=aggregateranks_fusion_w(rank,choose_num,1,weight);

    case 2
[new_rank,choose_serial]=aggregateranks_fusion_w(rank,choose_num,2,weight);

    case 3
[new_rank,choose_serial]=aggregateranks_fusion_w(rank,choose_num,3,weight);
    case 4
[new_rank,choose_serial]=aggregateranks_fusion_w(rank,choose_num,4,weight);

    case 5
[new_rank,choose_serial]=Bucklin_fusion_w(rank,choose_num,weight);

    case 6
    if nargin<5||isempty(option_agg)==1
    tuning=0.05;
    top_k=choose_num*5;
    MCmethod=1;
    else
        MCmethod=option_agg(1);
        top_k=option_agg(2);
        tuning=option_agg(3);
    end           
    [new_rank,choose_serial]=MCMC_fusion2_w(rank,choose_num,MCmethod,top_k,tuning,weight);   
    case 7
    if nargin<5||isempty(option_agg)==1
    tuning=0.05;
    MCmethod=2;
    top_k=choose_num*5;
    else
        MCmethod=option_agg(1);
        top_k=option_agg(2);
        tuning=option_agg(3);
    end           
    [new_rank,choose_serial]=MCMC_fusion2_w(rank,choose_num,MCmethod,top_k,tuning,weight);       

    case 8

    if nargin<5||isempty(option_agg)==1
    tuning=0.05;
    MCmethod=3;
    top_k=choose_num*5;
        else
        MCmethod=option_agg(1);
        top_k=option_agg(2);
        tuning=option_agg(3);
    end           
    [new_rank,choose_serial]=MCMC_fusion2_w(rank,choose_num,MCmethod,top_k,tuning,weight);   
    case 9
    [new_rank,choose_serial]=one_fusion_w(rank,choose_num,weight);    
    case 10
    [new_rank,choose_serial]=fall_fusion_w(rank,choose_num,weight);

    
    
end