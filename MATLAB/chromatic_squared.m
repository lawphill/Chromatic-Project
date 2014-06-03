function [combs psums] = chromatic(oldcolors,stats,X)
%% Determine the probability of every possible outcome for a given item


% UPDATE SO THAT SAME NUMBERS ARE CALCULATED CORRECTLY
nsockets = sum(oldcolors);
order = zeros(3^nsockets,nsockets);
for i = 1:nsockets
    order(:,i) = mod(floor(((1:3^nsockets)-1)/(3^(i-1))),3)+1;
end

oldorder = zeros(1,nsockets);

oldorder(1:oldcolors(1)) = 1;
oldorder(oldcolors(1)+1:oldcolors(1)+oldcolors(2)) = 2;
oldorder(oldcolors(1)+oldcolors(2)+1:nsockets) = 3;

logp = zeros(3^nsockets,1);
sums = zeros(3^nsockets,3);

% Calculate probabilities for every possible outcome
for i = 1:3^nsockets
    neworder = order(i,:);
    logp(i) = 0;
    for j = 1:nsockets
        logp(i) = logp(i) + log((stats(neworder(j)).^2+X) / ...
            (sum(stats.^2) + 3*X));
    end
    if sum(oldorder == neworder) == nsockets
        old = i;
    end
    
    for j = 1:3
        sums(i,j) = sum(neworder == j);
    end
end

logp = logp - log(1 - exp(logp(old)));
p = exp(logp);
p(old) = 0;

[combs, ia, ic] = unique(sums,'rows');
psums = zeros(1,length(combs));
for i = 1:length(combs)    
    psums(i) = sum(p(find(ic==i)));
end

end