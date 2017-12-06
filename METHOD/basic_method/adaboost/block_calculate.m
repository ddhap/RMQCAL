function [impurity,region]=block_calculate(m)
      type1=unique(m);
      type=length(type1);
      if type>3
          error('llll');
          return
      elseif type==1
          impurity=0;
      elseif type==2   
          impurity=0;
          
      elseif type==3   
          typenum1=length(find(m==type1(2)));
          typenum2=length(find(m==type1(3)));
          impurity=(min(typenum1,typenum2))/(max(typenum1,typenum2));
      else
          impurity=0;
          
      end
      region=size(m,1)*size(m,1);