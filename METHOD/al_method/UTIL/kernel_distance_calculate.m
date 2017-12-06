

function distance=kernel_distance_calculate(X1,X2,options)

input_options_num=3;
default_options=[0,1,1/(length(X1))];
if nargin <3
options = default_options;
else
    if length(options)<input_options_num
         tmp = default_options; 
         tmp(1:length(options)) = options; 
         options = tmp; 
    end  
end
method=options(1);
c_value=options(2);
g_value=options(3);
switch method
    case 0
    ker = struct('type','linear');
    case 1
    ker = struct('type','ploy','degree',g_value,'offset',c_value);    
    case 2
    g=c_value;
    ker = struct('type','gauss','width',g);
    case 3
    ker = struct('type','tanh','gamma',g_value,'offset',c_value);
end
k12 = kernel(ker,X1',X2');
k11 = kernel(ker,X1',X1');
k22 = kernel(ker,X2',X2');
distance=k11+k22-2*k12;

%K(Xi, Xi)?2K(Xi, Xj)+K(Xj, Xj).

