
%idx 分类结果 zt 原始数据 只有二维三维一维能画出
function h=ap_draw(zt,idx)

 dimention=size(zt,2);
   if dimention==1

           zt_tmp=[zt,zeros(length(zt),1)];
       for i=unique(idx)'
           ii=find(idx==i);
           h=plot(zt_tmp(ii,1),zt_tmp(ii,2),'o');
           hold on;
           col=rand(1,3);
           set(h,'Color',col,'MarkerFaceColor',col);
           xi1=zt_tmp(i,1)*ones(size(ii)); xi2=zt_tmp(i,2)*ones(size(ii));
           line([zt_tmp(ii,1),xi1]',[zt_tmp(ii,2),xi2]','Color',col);
       end;
      %axis equal tight;
       
       
       
   elseif dimention==2

       for i=unique(idx)'
           ii=find(idx==i);
           h=plot(zt(ii,1),zt(ii,2),'o');
           hold on;
           col=rand(1,3);
           set(h,'Color',col,'MarkerFaceColor',col);
           xi1=zt(i,1)*ones(size(ii)); xi2=zt(i,2)*ones(size(ii));
           line([zt(ii,1),xi1]',[zt(ii,2),xi2]','Color',col);
       end;
      %axis equal tight;
   elseif dimention==3

       for i=unique(idx)'
           ii=find(idx==i); h=plot3(zt(ii,1),zt(ii,2),zt(ii,3),'o'); hold on;
           col=rand(1,3); set(h,'Color',col,'MarkerFaceColor',col);
           xi1=zt(i,1)*ones(size(ii)); xi2=zt(i,2)*ones(size(ii)); xi3=zt(i,3)*ones(size(ii)); 
           line([zt(ii,1),xi1]',[zt(ii,2),xi2]',[zt(ii,3),xi3]','Color',col);
       end;
      %axis equal tight;
       
   else
       error('only 2D or 3D');
   end