% mainscript is rather short this time
clear; clc; close all;

% primary component count
comp_count = 40;
repeat = 100;

[tvec tlab tstv tstl] = readSets();

% look at the 100 digits in the training set
imsize = 28;
fim = zeros((imsize + 2) * 10 + 2);

for clid = 0:9
  rowid = clid * (imsize + 2) + 3;
  clsamples = find(tlab == clid)(1:10);
  for spid = 1:10
    colid = (spid - 1) * (imsize + 2) + 3;
    im = 1-reshape(tvec(clsamples(spid),:), imsize, imsize)';
    fim(rowid:rowid+imsize-1, colid:colid+imsize-1) = im;
  end
end
imshow(fim)

% check number of samples in each class
labels = unique(tlab)';
[labels; sum(tlab == labels); sum(tstl == labels)]

% compute and perform PCA transformation
[mu trmx] = prepTransform(tvec, comp_count);
tvec = pcaTransform(tvec, mu, trmx);
tstv = pcaTransform(tstv, mu, trmx);

% To successfully prepare ensemble you have to implement perceptron function
% I would use 10 first zeros and 10 fisrt ones
% and only 2 first primary components
% It'll allow printing of intermediate results in perceptron function

tenzeros = tvec(tlab == 0, 1:2)(1:10, :);
tenones  = tvec(tlab == 1, 1:2)(1:10, :);
pclass = tenzeros;
nclass = tenones;

plot(tenzeros(:,1), tenzeros(:,2), "r*", tenones(:,1), tenones(:,2), "bs")
hold on

% 1. Preparation of the function to compute separation plane parameters given a training set
% containing just two classes - perceptron. The easiest way to accomplish it is to use
% two-dimensional data sets , which can be visualized together with the separating plane

[sepplane, mispos, misneg] = perceptron(pclass, nclass);

x_vals = [-1, 1];
y_vals = (-sepplane(2) * x_vals - sepplane(1)) / sepplane(3);
plot(x_vals, y_vals, 'k-', 'LineWidth', 2)
hold off

% 2. Checking the algorithm for multidimensional digits data. You should store individual one vs.
% one classifiers quality to put them in your report. Because you’ll have to check expansion of
% the features reduce dimensionality of data with PCA (40-60 primary components).

disp("## 2. Perceptron sanity check ## ")

% Easy case
pclass = tvec(tlab == 0, :);
nclass = tvec(tlab == 1, :);
pa = 0; na = 0;
for i = 1:repeat
    [~, mp, mn] = perceptron(pclass, nclass);
    pa += 1 - mp / rows(pclass);
    na += 1 - mn / rows(nclass);
end
disp("easy (0 vs. 1)")
disp(pa / repeat)
disp(na / repeat)

% Difficult case
pclass = tvec(tlab == 4, :);
nclass = tvec(tlab == 9, :);
pa = 0; na = 0;
for i = 1:repeat
    [~, mp, mn] = perceptron(pclass, nclass);
    pa += 1 - mp / rows(pclass);
    na += 1 - mn / rows(nclass);
end
disp("difficult (4 vs. 9)")
disp(pa / repeat)
disp(na / repeat)

% 3. Canonical solution is 45 voting classifiers - one for each pair of digits - and making the final
% decision with unanimity voting (only digits with 9 votes are classified; if the number of
% votes is smaller classifier produces reject decision). You should report individual classifier
% error rates as well as quality of the ensemble. Quite interesting insight into ensemble
% operation can give you a confusion matrix.

disp("## 3. One vs One Classification ## ")

[ovo, err] = trainOVOensemble(tvec, tlab, @perceptron);
err

clab = unamvoting(tvec, ovo);
cfmx = confMx(tlab, clab)
compErrors(cfmx)

clab = unamvoting(tstv, ovo);
cfmx = confMx(tstl, clab)
compErrors(cfmx)

% 4. Preparing one-versus-rest ensemble of classifiers. Here you’ll have to think about
% organizing the training (a function similar to trainOVOensemble). Even before, you
% should decide about representation of classifiers in the matrix; with code reuse in mind it
% would be wise to put in the negative class label in the second column. Such a value that will
% allow you – with minimal changes in code – to use voting and unamvoting functions.
% Alternative is of course to write separate functions for OVR ensemble.

disp("## 4. Preparing One-versus-Rest Ensemble of Classifiers ## ")

[ovr, err] = trainOVRensemble(tvec, tlab, @perceptron);
err

clab = OVRvoting(tvec, ovr);
cfmx = confMx(tlab, clab)
compErrors(cfmx)

clab = OVRvoting(tstv, ovr);
cfmx = confMx(tstl, clab)
compErrors(cfmx)

% 6. Expand features with expandFeatures function. This function adds new features:
% x_i * x_j for i ≤ j.

disp("## 6–7. Expanded features + OVO / OVR ## ")

tvecE = expandFeatures(tvec);
tstvE = expandFeatures(tstv);

[ovoE, err] = trainOVOensemble(tvecE, tlab, @perceptron);
err

clab = unamvoting(tstvE, ovoE);
cfmx = confMx(tstl, clab)
compErrors(cfmx)

[ovrE, err] = trainOVRensemble(tvecE, tlab, @perceptron);
err

clab = OVRvoting(tstvE, ovrE);
cfmx = confMx(tstl, clab)
compErrors(cfmx)

% 9. Extra task: propose a solution better than any standard approach implemented earlier.

disp("## 9. Improved OVR (balanced training set) ## ")

[ovrB, err] = reduce_trainOVRensemble(tvecE, tlab, @perceptron, 0.8);
err

clab = OVRvoting(tstvE, ovrB);
cfmx = confMx(tstl, clab)
compErrors(cfmx)

