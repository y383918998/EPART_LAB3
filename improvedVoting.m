function clab = improvedVoting(tset, ovr, ovo)
% Improved classification using one-versus-rest and one-versus-one classifiers
%  tset - testing set
%  ovr  - one-versus-rest classifier
%  ovo  - one-versus-one classi
% Output:
%  clab - classification result
  
  % class processing
	labels = unique(ovr(:, 1));
	reject = max(labels) + 1;
  draw = reject+1;

  votes = OVRvoting(tset, ovr);

  % count votes
  valids = sum(votes, 2) == 1;
  % recycle votes
  recycle = sum(votes, 2) != 1;
  % count good votes
  decisions = votes .*valids;
  
  % find the most voted class
  [mv clab] = max(decisions, [], 2);
  
  % if there is no unanimity in votes, recycle
  clab(recycle) = draw;

  % mapping recycle to the second voting
  ovoclab = unamvoting(tset, ovo);

  % mapping recycle to the second voting
  for k=1:rows(clab)
    % if the class is draw, then map it to the second voting
    if (clab(k) == draw)
      clab(k) = ovoclab(k);
    end
  end
end