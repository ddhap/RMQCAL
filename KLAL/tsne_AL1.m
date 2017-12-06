function fea_new = tsne_AL1(X, labels, no_dims, initial_dims)

method='Pearson';
    if ~exist('labels', 'var')
        labels = [];
    end
    if ~exist('no_dims', 'var') || isempty(no_dims)
        no_dims = 2;
    end
     if ~exist('initial_dims', 'var') || isempty(initial_dims)
        initial_dims = min(50, size(X, 2));
    end

    
    % First check whether we already have an initial solution
    if numel(no_dims) > 1
        initial_solution = true;
        ydata = no_dims;
        no_dims = size(ydata, 2);
    else
        initial_solution = false;
    end
    
    % Normalize input data
    X = X - min(X(:));
    X = X / max(X(:));
    X = bsxfun(@minus, X, mean(X, 1));
    
    % Perform preprocessing using PCA
    if ~initial_solution
        disp('Preprocessing data using PCA...');
        if size(X, 2) < size(X, 1)
            C = X' * X;
        else
            C = (1 / size(X, 1)) * (X * X');
        end
        [M, lambda] = eig(C);
        [lambda, ind] = sort(diag(lambda), 'descend');
        M = M(:,ind(1:initial_dims));
        lambda = lambda(1:initial_dims);
        if ~(size(X, 2) < size(X, 1))
            M = bsxfun(@times, X' * M, (1 ./ sqrt(size(X, 1) .* lambda))');
        end
        X = bsxfun(@minus, X, mean(X, 1)) * M;
        clear M lambda ind
    end
    
    
    
    
    
    %X是利用PCA 降特征维后的数据
    fea_num=size(X,2);
    D1=nan(fea_num);
    D2=nan(fea_num);
    for i=1:fea_num
        for j=1:fea_num
            if i<=j
               x1=X(:,i);
               x2=X(:,j);
               switch method
                   case 'Pearson'
                      tmp=corrcoef(x1,x2); D1(i,j)=tmp(1,2);
               end
            else
               D1(i,j)=D1(j,i);
            end
        end
    end

 
fea_new= tsne_p1(D1, labels, no_dims);

    
    
    
    
    
    
    
    
    