function [ovrsp, errors] = reduce_trainOVRensemble(tset, tlab, htrain, reduce_val)
% Trains a set of linear classifiers (one versus rest class)
% on the training set using trainSelect function
% tset - training set samples
% tlab - labels of the samples in the training set
% htrain - handle to proper function computing separating plane
% ovrsp - one versus rest class linear classifiers matrix
%   the first column contains positive class label
%   the second column contains negative class label
%   columns (3:end) contain separating plane coefficients

  labels = unique(tlab);
  ovrsp = zeros(rows(labels), 2+1+ columns(tset));
  errors = zeros(rows(labels), 1);

  rows(labels)
  for i=1:rows(labels)
  i
	  % store labels in the first two columns
    ovrsp(i, 1:2) = [labels(i) 0];

	  % select samples of two digits from the training set
    posSamples = tset(tlab == labels(i), :);
    negSamples = reduce(tset, tlab, labels(i), reduce_val);

	  % train 5 classifiers and select the best one
    [sp misp misn] = trainSelect(posSamples, negSamples, 5, htrain);

    % what to do with errors?
    % it would be wise to add additional output argument
    % to return error coefficients

    % store the separating plane coefficients (this is our classifier)
    % in ovr matrix
    ovrsp(i, 3:end) = sp;
    errors(i)=(misp+misn)/(rows(posSamples)+rows(negSamples));
  end
