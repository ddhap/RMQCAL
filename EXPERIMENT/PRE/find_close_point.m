function serial=find_close_point(mat,pos,num)
serial=[];
for i=1:size(pos,1)
    dist=nan(size(mat,1),1);
    for j=1:size(mat,1)
        dist(j,1)=pdist([mat(j,:);pos(i,:)]);
    end
    [~,p2]=sort(dist,'ascend');
    serial=[serial;p2(1:num)];
end

        
    
    
    