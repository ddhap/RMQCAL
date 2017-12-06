
function scoref=norm_score(score)

score1=score';
min_value=(min(score1))';
sum_value=(sum(score1))';
min_value1=nan(size(score,1),size(score,2));
for i=1:size(score,2)
    min_value1(:,i)=min_value;
end

score2=score-min_value1;
sum_value=(sum(score2'))';
scoref=nan(size(score,1),size(score,2));
for i=1:size(scoref,1)
    if sum_value(i,1)~=0
    scoref(i,:)=score2(i,:)/(sum_value(i,1));
    else
    scoref(i,:)=zeros(1,size(score,2));  
    end
end