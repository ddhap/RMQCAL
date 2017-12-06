%{
clc
clear
sample_num=3;
rank_num=2;
rank=rank_generate(sample_num,rank_num);
choose_num=2;
[new_rank,choose_serial]=IPRAPA_fusion(rank,choose_num);
%}
function [new_rank,choose_serial]=IPRAPA_fusion(rank,choose_num)
new_rank_name=rank(1,:);
rank_tmp=rank(2:end,:);
sample_num=size(rank_tmp,2);
enginer_num=size(rank_tmp,1);
raw0=cell(enginer_num,3);
%我们不可能有重复，故有几个样本就有几个Element与cohort
for i=2:3
    for j=1:enginer_num
    raw0{j,i}=sample_num;
    end
end

for j=1:enginer_num
    [~,pp2]=sort(rank_tmp(j,:),'descend');
    name_tmp=new_rank_name(1,pp2);
    name_one=num2str(name_tmp(1,1));
    for i=2:size(name_tmp,2)
          name_one=[name_one,' < ',num2str(name_tmp(1,i))];
    end
    raw0{j,1}=name_one;
  
end

num0=cell2mat(raw0(:,2:3));
txt0=raw0(:,1);







% Find the elements and cohorts from each input list
sizeData = size(raw0);
% Col 1 = index of report in spreadsheet
% Col 2 = number of cohorts
% Col 3 = number of elements
report_ranks = zeros(sizeData(1),4);

% For the number of rows loaded from the raw data spreadsheet
for i = 1:sizeData(1)
    
    % If the current row is empty, continue to the next row
    if isempty(txt0{i,1})
        continue
    end
    
    % Store the row corresponding to the current report
    report_ranks(i,1) = i;
    
    % Find the number of cohorts (ranking levels) in the report
    cohort_indx = find(txt0{i,1} == '<'); % based on '<' separator
    numCohorts = 1+ length(cohort_indx);
    % Find number of elements in the report
    element_indx = find(txt0{i,1} == ','); % based on ',' separator
    numElements = length(element_indx);
    % Add number of cohort separators to get total number of elements
    numElements = numCohorts + numElements;
    % Sort the element indices in ascending order
    element_indx = sort([cohort_indx, element_indx]);
    % Store the number of cohorts and elements for each report
    report_ranks(i,2) = numCohorts; % number of cohorts for each report
    report_ranks(i,3) = numElements; % number of elements for each report
    % Store elements from the current input list
    newElements = cell(1,numElements);
    
    % get the input list from the first report    
    list = txt0{i,1}; 
    start_indx = 1;
    
    % for each element, get the corresponding characters that correspond
    % to its name
    for ii = 1:numElements
        if ii == numElements
            newElements{ii} = list(start_indx:end);
        else
            newElements{ii} = list(start_indx:element_indx(ii)-1);
            start_indx = element_indx(ii) + 1;
        end
        % remove leading or trailing whitespace from the element name
        newElements{ii} = strtrim(newElements{ii});
    end
    
    % append the list of elements from the current report to the total list
    % including all reports
    if i == 1
        allElements = newElements;
    else
        allElements = [allElements, newElements];
    end
end

% Remove all zero entries from input data
txt0(all(report_ranks==0, 2),:) = [];
num0(all(report_ranks==0, 2),:) = [];
raw0(all(report_ranks==0, 2),:) = [];
report_ranks(all(report_ranks==0, 2),:) = [];

% Get the list of unique elements (no repeats) from all the reports
allElements = unique(allElements);

% Order the reports for the elment ranking algorithm (order of pivoting)
% (1st based on number of cohorts and second based on number of elments in
% each report
report_ranks = sortrows(report_ranks, [-2,-3]);

%% Initialize variables for the iterative ranking process

% number of possible iterations to run
n = 10000;
% initialize ranks_converged variable as false
ranks_converged = false;
% number of reports in the dataset
num_reports = size(report_ranks,1);
% number of unique elements in the dataset
totalElements = length(allElements);
% Initialize array to count known pairwise comparisons
allPairs = zeros(totalElements,totalElements);
% Arbitrary range of the rankings (use 100 as default)
range = 100;
% Average rank for each element
average_rank = zeros(1,totalElements);
% Standard deviation of the rank for each element
stdev_rank = zeros(1,totalElements);
% Standard error of the rank for each element
sterr_rank = zeros(1,totalElements);
% Uncertainty of the rank for each element
uncertainty_rank = zeros(1,totalElements);
% Coefficient of variation of the rank for each element
coeffvar_rank = zeros(1,totalElements);
% Standard error/average
sterr_div_avg_rank = zeros(1,totalElements);
% List of pivot element indexes
pivot_list = zeros(1,num_reports);
% List rankings for the current iteration
current_rank = zeros(num_reports,totalElements);
% List cohorts for the current iteration (pivot elements get set to 0)
current_cohort = zeros(num_reports,totalElements);
% List of all cohorts in the input data (including pivot elements)
all_cohorts = zeros(num_reports,totalElements);
% Iterative average rankings for each iteration
iterative_ranks = zeros(n,totalElements);
% Indexes of each element in all input lists
element_idx = zeros(num_reports,totalElements);

%% Iteratively rank the elements in each report
% Pivoting algorithm is performed iteratively using each report in the
% spreadsheet for n iterations or until convergence.

tic; % start timer

% for the number of possible iterations
for i = 1:n
    % for the number of input lists
    for ii = 1:num_reports
        %% First list of the first iteration
        % Assign initial element ranks based on the input list with the
        % greatest information content (number of cohorts and elements)
        if i == 1 && ii == 1
            % Determine the number of cohorts and elements in the current
            % list ii
            numCohorts = report_ranks(i,2);
            numElements = report_ranks(i,3);
            % Get the first list of ordered elements
            list = txt0{ii,1};
            % Locate cohort separators indicated by, '<'
            cohort_indx = find(list == '<');
            % Locate separators for tied elements indicated by, ','
            element_indx = find(list == ',');
            % Sort element separator indexes in ascending order
            element_indx = sort([cohort_indx, element_indx]);
            % initialize start_index for reading element names to 1
            start_indx = 1;
            % Initialize currentElements, stores the names of elements in
            % this list
            currentElements = cell(1,numElements);
            % Initialize the pairsIdx, stores indexes of elements in the
            % current report for counting the number of pairwise
            % comparisons in the input data
            pairsIdx = zeros(1,numElements);
        
            % for the number of elements in the first list
            for j = 1:numElements
                % if on the last element in the list
                if j == numElements
                    % name of current element
                    currentElements = list(start_indx:end);
                    % remove white space from the name
                    currentElements = strtrim(currentElements);
                    % get the index of the element in the current report
                    idx = find(strcmp(allElements, currentElements));
                    % determine cohort of the element
                    current_cohort(ii,idx) = numCohorts;
                    
                else
                    % name of current element
                    currentElements = list(start_indx:element_indx(j)-1);
                    % remove white space from the name
                    currentElements = strtrim(currentElements);
                    % get the index of the element in the current report
                    idx = find(strcmp(allElements, currentElements));
                    % Search all possible cohorts for the correct cohort
                    % based on the element's position in the input list
                    for k = 1:numCohorts-1
                        % determine the cohort for the current element
                        if start_indx < cohort_indx(k)
                            current_cohort(ii,idx) = k;
                            % stop the loop once the correct cohort is
                            % found
                            break
                        else
                            current_cohort(ii,idx) = numCohorts;
                        end
                        
                    end
                    % increment the start index to the next element
                    start_indx = element_indx(j) + 1;
                end
                % Calculate a rank for each element based on its cohort
                % using the specified arbitrary range value
                current_rank(ii,idx) = range/numCohorts*...
                    current_cohort(ii,idx);
                % store the element index for determining known pairwise
                % comparisons
                pairsIdx(j) = idx;
                % Indicate presence of the element in the current report
                element_idx(ii,idx) = 1;
            end
            
            % Populate the list of known pairwise comparisons
            % For each element in the current list, tally one comparison
            % with each of the other elements in the list.
            for j = 1:length(pairsIdx)
                allPairs(pairsIdx(j),pairsIdx) = allPairs(pairsIdx(j),...
                    pairsIdx) + 1;
            end
            % Save the cohorts from the current list
            all_cohorts(ii,:) = current_cohort(ii,:);
            
            %% Subsequent iterations: use pivot method
            % Assign element ranks based on a pivot element in the current
            % report
            
        else % not the first list in the first iteration
            
            % Determine cohorts and indices of each of the elements in the
            % input list. Initialize common_index_empty to true, while loop
            % searches for a common element that can be used as the pivot
            % until one is found.
            common_index_empty = true;
            % initialize count of shifts applied to input lists
            shiftcount = 0;
            % search until pivot element is found
            while common_index_empty
                % number of cohorts and elements in the current list, ii
                numCohorts = report_ranks(ii,2);
                numElements = report_ranks(ii,3);
                % Get the list of ordered elements
                list = txt0{ii,1};
                % Locate cohort separators indicated by, '<'
                cohort_indx = find(list == '<');
                % Locate separators for tied elements indicated by, ','
                element_indx = find(list == ',');
                % Sort element separator indexes in ascending order
                element_indx = sort([cohort_indx, element_indx]);
                % initialize start_index for reading element names to 1
                start_indx = 1;
                % Initialize currentElements, stores the names of elements
                % in list, ii
                currentElements = cell(1,numElements);
                % Initialize the pairsIdx variable for the current list,
                % stores the element indexes for determining the number of
                % pairwise comparisons in input lists.
                pairsIdx = zeros(1,numElements);
                
                % for the number of elements in list ii
                for j = 1:numElements
                    % if on the last element in the list
                    if j == numElements
                        % name of current element
                        currentElements = list(start_indx:end);
                        % remove white space from the name
                        currentElements = strtrim(currentElements);
                        % get the index of the element in the current
                        % report
                        idx = find(strcmp(allElements, currentElements));
                        % determine cohort of the element
                        current_cohort(ii,idx) = numCohorts;
                        
                    else
                        % name of current element
                        currentElements = list(start_indx:...
                            element_indx(j)-1);
                        % remove white space from the name
                        currentElements = strtrim(currentElements);
                        % get the index of the element in the current
                        % report
                        idx = find(strcmp(allElements, currentElements));
                        % Search all possible cohorts for the correct
                        % cohort based on the element's position in the
                        % input list
                        for k = 1:numCohorts-1
                            % determine the cohort for the current element
                            if start_indx < cohort_indx(k)
                                current_cohort(ii,idx) = k;
                                % stop the loop once the correct cohort is
                                % found
                                break
                            else
                                current_cohort(ii,idx) = numCohorts;
                            end
                            
                        end
                        % increment the start index to the next element
                        start_indx = element_indx(j) + 1;
                    end
                    
                    % Save the idexes of the elements for determining known
                    % pairwise comparisons
                    pairsIdx(j) = idx;
                    % Indicate presence of the element in the current
                    % report
                    element_idx(ii,idx) = 1;
                end
                
                %% Determine which element to use as the pivot
                
                % Select the pivot element as an element common with
                % previously ranked lists, with the highest cohort
                
                % If we are on the first report in a new iteration
                if ii == 1
                    % Use the ranks from the previous iteration excluding
                    % the first report to select a pivot element and start
                    % the ranking in the next iteration
                    common_indx = find(sum(current_cohort(2:end,:),1).*...
                        current_cohort(ii,:)>0);
                else
                    % If we are not on the first report, use only element
                    % ranks from the current iteration
                    common_indx = find(sum(current_cohort(1:ii-1,:),1).*...
                        current_cohort(ii,:)>0);
                end
                
                % If a common index cannot be found for the current report,
                % move the report down in the list of input data and try
                % the next one
                if isempty(common_indx)
                    % increment the number of shifts required to find the
                    % pivot
                    shiftcount = shiftcount + 1;
                    report_ranks(ii:end,2:end) = circshift(report_ranks...
                        (ii:end,2:end),[-1,0]);
                    current_cohort(ii,:) = 0;
                    current_rank(ii,:) = 0;
                    txt0(ii:end) = circshift(txt0(ii:end,:),[-1,0]);
                    num0(ii:end,:) = circshift(num0(ii:end,:),[-1,0]);
                    raw0(ii:end,:) = circshift(raw0(ii:end,:),[-1,0]);
                else
                    common_index_empty = false;
                    if shiftcount > 0
                        % restore the original order of the input lists
                        % after the next report with a pivot is found to
                        % maintain the order of greatest information
                        % content.
                        report_ranks(ii+1:end,2:end) = circshift(...
                            report_ranks(ii+1:end,2:end),[shiftcount,0]);
                        txt0(ii+1:end) = circshift(txt0(ii+1:end,:),...
                            [shiftcount,0]);
                        num0(ii+1:end,:) = circshift(num0(ii+1:end,:),...
                            [shiftcount,0]);
                        raw0(ii+1:end,:) = circshift(raw0(ii+1:end,:),...
                            [shiftcount,0]);
                        shiftcount = 0;
                    end
                end
            end
            
            % If we are on the first iteration populate the pairwise
            % comparisons matrix
            if i == 1
                for j = 1:length(pairsIdx)
                    allPairs(pairsIdx(j),pairsIdx) = allPairs(...
                        pairsIdx(j),pairsIdx) + 1;
                end
            elseif i == 2
                % Set the diagonal to zero to remove self-comparisons
                allPairs(logical(eye(size(allPairs)))) = 0;
            end
            
            %% Find the pivot element
            % Determine pivot element based on maximum common cohort with
            % ties broken by the rank uncertainty
            
            % Determine the max cohort of the common cohorts
            [maxval,~] = max(current_cohort(ii,common_indx));
            % Find element(s) with the maximum common cohort
            pivot_indx = find(sort(current_cohort(ii,common_indx),1,...
                'descend')>maxval-1);
            pivot_indx = common_indx(pivot_indx);
            
            % if there is more than one possible pivot index (multiple
            % elements with the max common cohort), check which has the
            % lowest cohort uncertainty and use it as the pivot
            if length(pivot_indx) > 1
                % initialize the cohort uncertainty variable
                uncertainty = zeros(1,length(pivot_indx));
                
                % for each potential pivot element
                for k = 1:length(pivot_indx)
                    
                    % Get cohort data for the potential pivot element
                    data = current_cohort(:,pivot_indx(k));
                    % Exclude the current report from the uncertainty
                    % calculation
                    data(ii) = 0;
                    % Find all report indexes with nonzero cohorts for the
                    % potential pivot element
                    data_indx = find(data>0);
                    % Get the number of cohorts for each report
                    data = report_ranks(data_indx,2);
                    % Calculate the cohort uncertainty
                    uncertainty(k) = sqrt(sum((1./data).^2))/length...
                        (data)*range;                    
                end
                
                % determine the pivot index based on minimum uncertainty
                [~, min_indx] = min(uncertainty);
                pivot_indx = pivot_indx(min_indx);
                
            end
            
            %% Calculate element ranks using the pivot
            
            % Calculate the pivot rank as the average of the ranks for the
            % chosen pivot element from the current iteration
            pivot = sum(current_rank(:,pivot_indx))/length(find(...
                current_rank(:,pivot_indx)>0));
            
            % Calculate the rank for each element in the report based on
            % its cohort and the current pivot value
            report_indx = find(current_cohort(ii,:)>0);
            pivot_cohort = current_cohort(ii,pivot_indx);
            % calculate current rank based on pivot_cohort
            current_rank(ii,report_indx) = pivot/pivot_cohort*...
                current_cohort(ii,report_indx);
            
            % Set pivot element rank and cohort to zero to prevent double
            % counting the ranking for that element
            current_rank(ii,pivot_indx) = 0;
            % store the cohorts for the current report including the pivot
            % element
            all_cohorts(ii,:) = current_cohort(ii,:);
            current_cohort(ii,pivot_indx) = 0;
            % store the selected pivot element
            pivot_list(ii) = pivot_indx;
            
        end
    end
    
    
    %======================
    %%计算结束原始excel转current_cohort
    %{
     current_cohort
     current_rank
    %}
    %======================
    
    %% Statistical analysis of the rankings
    
    % Store last iterations average ranks to check for convergence
    old_rank = average_rank;
    
    % Average rankings after the current iteration
    average_rank = sum(current_rank(:,:),1)./sum((current_rank(:,:)>0),1);
    
    % Normalize ranks to the specified range based on the maximum average
    % rank after each iteration
    norm_factor = range/max(average_rank);
    current_rank = current_rank.*norm_factor;
    average_rank = average_rank.*norm_factor;
    
    % Store the average normalized rank for each iteration
    iterative_ranks(i,:) = average_rank;
    
    % Check for convergence. Conversion tolerance = max difference between
    % ranks of 10^-3
    rank_differences = abs(old_rank-average_rank);
    if max(rank_differences) < 10^-3
        % Update ranks_converged to true
        ranks_converged = true;
    end
    
    % Calculate statistics for each element after last iteration
    if i == n || ranks_converged;
        min_ranks = zeros(1,num_reports);
        for mm = 1:num_reports
            row = current_rank(mm,:);
            row(row==0) = [];
            min_ranks(mm) = min(row);
        end
        
        for m = 1:totalElements
            
            col = current_rank(:,m);
            col(col==0) = [];
            % standard deviation
            stdev_rank(m) = std(col);
            % standard error
            sterr_rank(m) = stdev_rank(m)/sqrt(length(col));
            % calculate uncertainty
            col = current_cohort(:,m);
            list_indx = find(col>0);
            col(col==0) = [];
            uncertainty_rank(m) = sqrt(sum(min_ranks(list_indx).^2))/...
                length(col);
            
        end
        % coefficient of variation
        coeffvar_rank = stdev_rank./average_rank;
        % standard error divided by the average
        sterr_div_avg_rank = sterr_rank./average_rank;
        
    end
    
    % Terminate iterations if element ranks have converged
    if ranks_converged
        break
    end
    
end

%% Determine Final Rankings

% remove zero entries from iterative ranks. Occurs if convergence occurs
% before n iterations.
iterative_ranks(iterative_ranks==0) = [];
iterative_ranks = reshape(iterative_ranks, [i, totalElements]);
% Rank the elements according to the result
[~, rank_indx] = sort(average_rank);
P2=fliplr(rank_indx);
new_rank=zeros(1,size(P2,2));
for i=1:size(new_rank,2)
       new_rank(1,P2(i))=i; 
end     
new_rank=[new_rank_name;new_rank];

choose_serial=new_rank_name(P2(1:choose_num));


%{
current_cohort
current_rank
%}



