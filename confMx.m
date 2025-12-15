function cfmx = confMx(truelab, declab)
% Computes confusion matrix cfmx given
%       truelab - column vector of ground-truth labels
%       declab - column vector of classifiers decisions
% Output:
%       cfmx - confusion matrix:
%               rows - are for ground truth
%               columns - are for classfier output
% It's assumed that rejection decision is coded as max(labels)+1

  % collect all labels that appear either in ground truth or decisions
  % (includes possible rejection label)
  labels = unique([truelab; declab]);

  % initialize confusion matrix (rows: true labels, cols: decided labels)
  cfmx = zeros(rows(labels), rows(labels));

  % map arbitrary label values (e.g. 0–9 with rejection 10) to 1-based indices
  for i = 1:rows(truelab)
    rid = find(labels == truelab(i));
    cid = find(labels == declab(i));
    cfmx(rid, cid) += 1;
  end
end
