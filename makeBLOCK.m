function list=makeBLOCK(experiment_result_performance,serial)
         list=nan(6,14);
         list(1,:)=[0,5,10,15,20,25,30,0,5,10,15,20,25,30];
         list(2:6,2:7)=experiment_result_performance.accuracy(:,serial);
         list(2:6,9:14)=experiment_result_performance.F1measure(:,serial);
