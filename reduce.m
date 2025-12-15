function rds = reduce(tset, tlab, lab, percent)
    % reduce the number of samples of the class lab to percent
    % of the original number of samples
    % tset - train set
    % tlab - train labels
    % lab - the class to be reduced
    % percent - the percentage of samples to be kept
    % rds - reduced set

    % get the unique labels
    labels = unique(tlab);
    rds=[];

    % get the samples of the class lab
    for i=1:rows(labels)
        if(i != lab) % if it is not the class we want to reduce
            % get the samples of the class lab
            all_other = tset(tlab == labels(i),:);
            % get the number of samples to keep
            num_of_samples = ceil(rows(all_other)*percent);
            % add the samples to the reduced set
            rds = [rds; all_other( randperm(rows(all_other),num_of_samples) ,:) ];
        end
    endfor
end