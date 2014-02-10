function logp = chrome_probs(data,X)
%% Calculate the probability of a set of chromatic data
% given the variable X with data in the following format
% data(:,1:3) = stat requirements (STR,DEX,INT)
% data(:,4:6) = sums of old colors (#red,#green,#blue)
% data(:,7:9) = sums new colors (#red,#green,#blue)

logp = 0;
n = size(data);

for i = 1:n(1)
    % calculate probability of new configuration
    pnew = ((data(i,1)+X)/(sum(data(i,1:3))+3*X))^data(i,7) * ...
        ((data(i,2)+X)/(sum(data(i,1:3))+3*X))^data(i,8) * ...
        ((data(i,3)+X)/(sum(data(i,1:3))+3*X))^data(i,9);
    
    % calculate odds of landing the exact same configuration
    pold = ((data(i,1)+X)/(sum(data(i,1:3))+3*X))^data(i,4) * ...
        ((data(i,2)+X)/(sum(data(i,1:3))+3*X))^data(i,5) * ...
        ((data(i,3)+X)/(sum(data(i,1:3))+3*X))^data(i,6);
    
    ptrue = pnew / (1-pold);
    logp = logp + log(ptrue);
end

end