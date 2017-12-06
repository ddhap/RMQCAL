 %{
rank=[1,3,5,7,9;5,2,1,3,4;5,2,1,3,4;5,2,1,3,4];
method=2;
choose_num=4;
option_agg=[];
[new_rank,choose_serial]=agg_rank(method,rank,choose_num,option_agg);
%}

function [new_rank,choose_serial]=agg_rank(method,rank,choose_num,option_agg)

switch method
    case 1
[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,0);

    case 2
[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,1);

    case 3
[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,2);

    case 4
[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,3);
    case 5
[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,4);

    case 6
[new_rank,choose_serial]=aggregateranks_fusion(rank,choose_num,5);

    case 11
[new_rank,choose_serial]=IPRAPA_fusion(rank,choose_num);

    case 7
        
    score_give=1:size(rank,2)+100;
    if nargin<4
    option_agg=ones(1,(size(rank,1)-1));
    end
    [new_rank,choose_serial]=Borda_fusion(rank,choose_num,score_give,option_agg);

    case 9
    [new_rank,choose_serial]=Bucklin_fusion(rank,choose_num);

    case 10
    if nargin<4
    option_agg=[3,0,1];
    end    
    [new_rank,choose_serial]=Condorcet_fusion(rank,choose_num,option_agg);

    case 8
    [new_rank,choose_serial]=reciprocal_fusion(rank,choose_num);


    case 12
    if nargin<4
    option_agg=[choose_num;choose_num+1;choose_num+2];
    end               
    [new_rank,choose_serial]=fall_fusion(rank,choose_num,option_agg);
    case 13
    if nargin<4||isempty(option_agg)==1
    tuning=0.05;
    top_k=choose_num*5;
    MCmethod=1;
    else
        MCmethod=option_agg(1);
        top_k=option_agg(2);
        tuning=option_agg(3);
    end           
    [new_rank,choose_serial]=MCMC_fusion2(rank,choose_num,MCmethod,top_k,tuning);   
    case 14
    if nargin<4||isempty(option_agg)==1
    tuning=0.05;
    MCmethod=2;
    top_k=choose_num*5;
    else
        MCmethod=option_agg(1);
        top_k=option_agg(2);
        tuning=option_agg(3);
    end           
    [new_rank,choose_serial]=MCMC_fusion2(rank,choose_num,MCmethod,top_k,tuning);       
    case 15
    if nargin<4||isempty(option_agg)==1
    tuning=0.05;
    MCmethod=3;
    top_k=choose_num*4;
        else
        MCmethod=option_agg(1);
        top_k=option_agg(2);
        tuning=option_agg(3);
    end           
    [new_rank,choose_serial]=MCMC_fusion2(rank,choose_num,MCmethod,top_k,tuning);   
end





