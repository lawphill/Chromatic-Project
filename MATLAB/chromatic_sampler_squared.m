%% Chromatic Sampler
% A Metropolis-Hastings sampler to sample the value of X

T = 2000;
burnin = 500;
%burnin=0;
nchains = 1;

% INSERT DATA FILE HERE
alldata = xlsread('DataFiles/ChromeProbsMar31.xlsx');
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
X = zeros(nchains,T); xmin = 0; xmax = 1000;
X(:,1) = round(randi(xmax-xmin,nchains,1)+xmin);

d.X = zeros(nchains,T-burnin);
if burnin == 0
    d.X(:,1) = X(:,1);
end
d.alpha = zeros(nchains,T-burnin);
d.r = zeros(nchains,T-burnin);
d.newX = zeros(nchains,T-burnin);

% Begin sampling
for t = 2:T
    if mod(t,100)==0
        t
    end
    newX = X(:,t-1) + round(randn(nchains,1)*10); % shift value by round(Gaussian(0,5))
    newX(newX<xmin) = xmin; % stay in bounds
    newX(newX>xmax) = xmax;
    
    % Prior probability is assumed to be uniform
    alpha = exp(chrome_probs_squared(data,newX)-chrome_probs_squared(data,X(:,t-1)));
    
    r = rand(nchains,1);
    
    for i = 1:nchains
        if alpha(i) >= 1 || alpha(i) >= r(i)
            X(i,t) = newX(i);
        else
            X(i,t) = X(i,t-1);
        end
    end
    
    if t > burnin
        d.X(:,t-burnin) = X(:,t);
        d.newX(:,t-burnin) = newX;
        d.alpha(:,t-burnin) = alpha;
        d.r(:,t-burnin) = r;
    end
end

d.mean = mean(d.X,2);
d.prctile = prctile(d.X',[5,95]);
%plot(d.X)

clearvars T burnin alldata count i line X xmin xmax newX alpha t r;