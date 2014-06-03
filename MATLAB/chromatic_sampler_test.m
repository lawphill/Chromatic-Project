%% Chromatic Sampler
% A Metropolis-Hastings sampler to sample the value of X

T = 3000;
burnin = 500;
nchains = 5;

% INSERT DATA FILE HERE
data = zeros(1200,9);
trueX = 15; nsockets = 2;
for i = 1:length(data)
    data(i,1:3) = [0 78 0];
    if i == 1
        data(i,4:6) = [0 nsockets 0];
    else
        data(i,4:6) = data(i-1,7:9);
    end
    data(i,7:9) = roll_chrome(data(i,1:6),trueX);
end

% Initialize parameters
X = zeros(nchains,T); xmin = 0; xmax = 100;
X(:,1) = randi(xmax-xmin,nchains,1)+xmin;

d.X = zeros(nchains,T-burnin);
d.alpha = zeros(nchains,T-burnin);
d.r = zeros(nchains,T-burnin);
d.newX = zeros(nchains,T-burnin);

% Begin sampling
for t = 2:T
    newX = X(:,t-1) + randn(nchains,1)*1; % shift value by Gaussian(0,1)
    newX(newX<xmin) = xmin; % stay in bounds
    newX(newX>xmax) = xmax;
    
    % Prior probability is assumed to be uniform
    alpha = exp(chrome_probs(data,newX)-chrome_probs(data,X(:,t-1)));
    
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