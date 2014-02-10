%% Chromatic Sampler
% A Metropolis-Hastings sampler to sample the value of X

T = 10000;
burnin = 500;

alldata = xlsread('DataFiles/ChromeProbsFeb4.xlsx');
alldata = alldata(:,1:9); % delete any notes to the sides
alldata(isnan(alldata)) = 0; % replace all NaNs with 0s

% Remove incorrect lines
count = 1;
for i = 1:length(alldata)
    line = alldata(i,:);
    % Must have same number of sockets before and after the roll
    % Must have more than zero sockets listed before the roll
    if sum(line(4:6))==sum(line(7:9)) && sum(line(4:6))>0
        data(count,:) = line;
        count = count + 1;
    end
end

% Initialize parameters
X = zeros(1,T); xmin = 0; xmax = 100;
X(1) = randi(xmax-xmin)+xmin;

d.X = zeros(1,T-burnin);
d.alpha = zeros(1,T-burnin);
d.r = zeros(1,T-burnin);
d.newX = zeros(1,T-burnin);

% Begin sampling
for t = 2:T
    newX = X(t-1) + randn*1; % shift value by Gaussian(0,1)
    if newX < xmin
        newX = xmin;
    elseif newX > xmax
        newX = xmas;
    end
    
    % Prior probability is assumed to be uniform
    alpha = exp(chrome_probs(data,newX)-chrome_probs(data,X(t-1)));
    
    r = rand;
    
    if alpha >= 1 || alpha >= r
        X(t) = newX;
    else
        X(t) = X(t-1);
    end
    
    if t > burnin
        d.X(t-burnin) = X(t);
        d.newX(t-burnin) = newX;
        d.alpha(t-burnin) = alpha;
        d.r(t-burnin) = r;
    end
end

d.mean = mean(d.X);
d.prctile = prctile(X,[5,95]);
%plot(d.X)

clearvars T burnin alldata count i line X xmin xmax newX alpha t;