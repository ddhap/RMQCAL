function whether_use=input_detect(parameter_input)
whether_use=1;
if size(parameter_input,1)<2||size(parameter_input,2)~=15
   errordlg('Can not find the input block');
   whether_use=0;
   return
else
   h=waitbar(0,'start input detection');
   for i=2:size(parameter_input,1)
       %% data_name
       if isempty(parameter_input{i,1})==1
          errordlg(['database name in line ',num2str(i),' is empty']);
              whether_use=0;
              return
       else
           if exist(parameter_input{i,1},'file')==0
              errordlg(['database in line ',num2str(i),' is not exist']);
              whether_use=0;
              return
           end
       end
       %% dataflow_name
       ctemp=isempty(parameter_input{i,3})+isempty(parameter_input{i,4})+isempty(parameter_input{i,5});
       if isempty(parameter_input{i,2})==1
          if (ctemp~=0)
          errordlg(['dataflow name in line ',num2str(i),' is empty']);
          whether_use=0;
          return
          end
       else
           if exist(parameter_input{i,2},'file')==0
              errordlg(['dataflow in line ',num2str(i),' is not exist']);
              whether_use=0;
              return
           end
       end
       %% option_dataflow.batch_size
       if isempty(parameter_input{i,2})==1
       if parameter_input{i,3}<0||sum(fix(parameter_input{i,3})~=parameter_input{i,3})||length(parameter_input{i,3})~=1
              errordlg(['batch_size in line ',num2str(i),' is not suit']);
              whether_use=0;
              return
       end
       end
       %% option_dataflow.firstbatch_size
       if isempty(parameter_input{i,2})==1
       if parameter_input{i,4}<2||sum(fix(parameter_input{i,4})~=parameter_input{i,4})||length(parameter_input{i,4})~=1
              errordlg(['firstbatch_size in line ',num2str(i),' is not suit']);
              whether_use=0;
              return
       end
       end
       %% option_dataflow.firstbatch_selection_strategy
       if isempty(parameter_input{i,2})==1
       if strcmp(parameter_input{i,5},'random')==0&&strcmp(parameter_input{i,5},'manual')==0&&strcmp(parameter_input{i,5},'cluster')==0
              errordlg(['firstbatch_selection_strategy in line ',num2str(i),' is not suit']);
              whether_use=0;
              return
       end
       end
     %% option_dataflow.first_choose_array
       if isempty(parameter_input{i,2})==1
          if strcmp(parameter_input{i,5},'manual')==1
             if isempty(parameter_input{i,6})==1||sum(fix(parameter_input{i,6})~=parameter_input{i,6})||min(parameter_input{i,6})<1||length(parameter_input{i,6})~=parameter_input{i,4}
               errordlg(['first_choose_array in line ',num2str(i),' is not suit']);
               whether_use=0;
               return
             end
          elseif strcmp(parameter_input{i,5},'cluster')==1
             if isempty(parameter_input{i,6})==1||sum(fix(parameter_input{i,6})~=parameter_input{i,6})||(parameter_input{i,6}~=0&&parameter_input{i,6}~=1)||length(parameter_input{i,6})~=1
               errordlg(['first_choose_array in line ',num2str(i),' is not suit']);
               whether_use=0;
               return   
             end
          end
       end
       
      %% option_dataflow.extra_buffersize
      if isempty(parameter_input{i,2})==1
         if isempty(parameter_input{i,7})==1||sum(fix(parameter_input{i,7})~=parameter_input{i,7})||parameter_input{i,7}<0||length(parameter_input{i,7})~=1
               errordlg(['extra_buffersize in line ',num2str(i),' is not suit']);
               whether_use=0;
               return   
         end
      end
               
      %% option_al.choose_num
      if isempty(parameter_input{i,8})==1||sum(fix(parameter_input{i,8})~=parameter_input{i,8})||parameter_input{i,8}<1||length(parameter_input{i,8})~=1
          errordlg(['choose_num in line ',num2str(i),' is not suit']);
          whether_use=0;
               return   
      end
      
      %% option_al.choose_strategies
      if isempty(parameter_input{i,9})==1||sum(fix(parameter_input{i,9})~=parameter_input{i,9})||(min(parameter_input{i,9})<1)||(max(parameter_input{i,9})>14) %%active 方法            
          errordlg(['AL choose_strategies in line ',num2str(i),' is not suit']);
          whether_use=0;
          return   
       end
       
      %% option_al.fuision_strategies
       if length(parameter_input{i,9})>1
          if isempty(parameter_input{i,10})==1||sum(fix(parameter_input{i,10})~=parameter_input{i,10})||parameter_input{i,10}<1||parameter_input{i,10}>10||length(parameter_input{i,10})~=1 %%fusion 方法
          errordlg(['AL fuision_strategies in line ',num2str(i),' is not suit']);
          whether_use=0;
          return   
          end
       end

       %% option_al.fuision_array
       
       %% option_ml.method
       if strcmp(parameter_input{i,12},'svm')==0&&strcmp(parameter_input{i,12},'bayes')==0
          errordlg(['ML method in line ',num2str(i),' is not suit']);
          whether_use=0;
          return   
       end
      %% option_ml.parameter
      
      
      %% option_al.end_requirement_way
      if isempty(parameter_input{i,14})==1||sum(fix(parameter_input{i,14})~=parameter_input{i,14})||parameter_input{i,14}<1||length(parameter_input{i,14})~=1||parameter_input{i,14}>5
          errordlg(['end_requirement_way in line ',num2str(i),' is not suit']);
          whether_use=0;
               return   
      end
       
       %% option_al.end_requirement_options
       if parameter_input{i,14}==2
          if isempty(parameter_input{i,15})==1||sum(fix(parameter_input{i,15})~=parameter_input{i,15})||parameter_input{i,15}<1||length(parameter_input{i,15})~=1||parameter_input{i,15}>100
          errordlg(['end_requirement_options in line ',num2str(i),' is not suit']);
          whether_use=0;
          return   
          end
           
       elseif parameter_input{i,14}==3
          if isempty(parameter_input{i,15})==1||sum(fix(parameter_input{i,15})~=parameter_input{i,15})||parameter_input{i,15}<1||length(parameter_input{i,15})~=1
          errordlg(['end_requirement_options in line ',num2str(i),' is not suit']);
          whether_use=0;
          return   
          end
       elseif parameter_input{i,14}==4
          if isempty(parameter_input{i,15})==1||sum(fix(parameter_input{i,15})~=parameter_input{i,15})||parameter_input{i,15}<1||length(parameter_input{i,15})~=1
          errordlg(['end_requirement_options in line ',num2str(i),' is not suit']);
          whether_use=0;
          return   
          end
        elseif parameter_input{i,14}==5
          if isempty(parameter_input{i,15})==1||parameter_input{i,15}>1||length(parameter_input{i,15})~=1||parameter_input{i,15}<0
          errordlg(['end_requirement_options in line ',num2str(i),' is not suit']);
          whether_use=0;
          return   
          end    
       end
       

     
    waitbar((i-1)/(size(parameter_input,1)-1),h,['detected ',num2str(i-1),' line, total is',num2str((size(parameter_input,1)-1))]);

       
  
   end
end
close(h);