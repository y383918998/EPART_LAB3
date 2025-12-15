function rds = reduce(tset, tlab, lab, percent)
    % reduce the number of samples of the class lab to percent
    % of the original number of samples
    % tset - train set
    % tlab - train labels
    % lab - the class to be reduced
    % percent - the percentage of samples to be kept
    % rds - reduced set

    labels = unique(tlab);
    rds = [];

    % keep a balanced subset of all negative classes
    for i = 1:rows(labels)
        current_label = labels(i);
        if current_label ~= lab
            all_other = tset(tlab == current_label, :);
            num_of_samples = ceil(rows(all_other) * percent);
            rds = [rds; all_other(randperm(rows(all_other), num_of_samples), :)];
        end
    endfor
end
