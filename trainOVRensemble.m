function [ovrsp, errors] = trainOVRensemble(tset, tlab, htrain)
% Trains a set of linear classifiers (one versus rest)
% on the training set using trainSelect function
% tset - training set samples
% tlab - labels of the samples in the training set
% htrain - handle to proper function computing separating plane
% ovrsp - one versus rest class linear classifiers matrix
%   the first column contains positive class label
%   the second column contains -1 value
%   columns (3:end) contain separating plane coefficients

  labels = unique(tlab);
  errors = zeros(rows(labels), 1);
  ovrsp = zeros(rows(labels), 2 + 1 + columns(tset));
  
  rows(labels)
  for i=1:rows(labels)
    i
	% store label in the first column
    ovrsp(i, 1:2) = [labels(i) 0];
	
	% select samples of two digits from the training set
    posSamples = tset(tlab == labels(i), :);
    negSamples = tset(tlab ~= labels(i), :);
	
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
end
