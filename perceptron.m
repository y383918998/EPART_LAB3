function [sepplane mispos misneg] = perceptron(pclass, nclass)
% Computes separating plane (linear classifier) using
% perceptron method.
% pclass - 'positive' class (one row contains one sample)
% nclass - 'negative' class (one row contains one sample)
% Output:
% sepplane - row vector of separating plane coefficients
% mispos - number of misclassified samples of pclass
% misneg - number of misclassified samples of nclass

  % training data aggregation and denormalization (of the neg class)
  sepplane = rand(1, columns(pclass) + 1) - 0.5;
  tset = [ ones(rows(pclass), 1) pclass; -ones(rows(nclass), 1) -nclass];
  nPos = rows(pclass); % number of positive samples
  nNeg = rows(nclass); % number of negative samples

  i = 1;
  do 
    %%% YOUR CODE GOES HERE %%%
    %% You should:
    %% 1. Check which samples are misclassified (boolean column vector)
    misclassified = tset * sepplane' <0;

    %% 2. Compute separating plane correction 
    %%		This is sum of misclassfied samples coordinate times learning rate
    correction = sum(tset(misclassified,:), 1);


    %% 3. Modify solution (i.e. sepplane)
    sepplane = sepplane + correction;


    %% 4. Optionally you can include additional conditions to the stop criterion
    splen = sqrt(sumsq(sepplane));
	corlen = sqrt(sumsq(correction));
	if corlen < 0.001 * splen
      i
      break
    end


    res = tset * sepplane';
    misclass = res<0;
    sepplane = sepplane + sqrt(1/i)*sum(tset(misclass,:));%sqrt(1/i)
    
    %%		200 iterations can take a while and probably in most cases is unnecessary

    ++i;
  until i > 100;

  %%% YOUR CODE GOES HERE %%%
  %% You should:
  %% 1. Compute the numbers of false positives and false negatives
  mispos = sum(misclassified(1:nPos));
  misneg = sum(misclassified(nPos+1:end));
end
