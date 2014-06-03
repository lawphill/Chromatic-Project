function logp = chrome_probs(data,X)
%% Calculate the probability of a set of chromatic data
% given the array X with data in the following format
% data(:,1:3) = stat requirements (STR,DEX,INT)
% data(:,4:6) = sums of old colors (#red,#green,#blue)
% data(:,7:9) = sums new colors (#red,#green,#blue)

logp = zeros(length(X),1);
n = size(data);

for i = 1:n(1)
    same=0;
    if sum(data(i,4:6)~=data(i,7:9)) == 0
        same = 1;
    end
    
    nsockets = sum(data(i,7:9));

    ncombin = ((factorial(nsockets))/(factorial(data(i,7))*factorial(nsockets-data(i,7)))) ...
    *((factorial(nsockets-data(i,7)))/(factorial(data(i,8))*factorial(data(i,9))));
    
    % calculate probability of new configuration
    pnew = ((data(i,1)+X)./(sum(data(i,1:3))+3.*X)).^data(i,7) .* ...
        ((data(i,2)+X)./(sum(data(i,1:3))+3.*X)).^data(i,8) .* ...
        ((data(i,3)+X)./(sum(data(i,1:3))+3.*X)).^data(i,9) ...
        .* ncombin;
    
    % calculate odds of landing the exact same configuration
    pold = ((data(i,1)+X)./(sum(data(i,1:3))+3.*X)).^data(i,4) .* ...
        ((data(i,2)+X)./(sum(data(i,1:3))+3.*X)).^data(i,5) .* ...
        ((data(i,3)+X)./(sum(data(i,1:3))+3.*X)).^data(i,6);
    
    if same == 0
        ptrue = pnew ./ (1-pold);
    else
        ptrue = (pnew - pold) ./ (1-pold);
    end
%    history.logp(i)=log(ptrue);
%    history.pnew(i)=pnew;
%    history.pold(i)=pold;
%    history.same(i)=same;
%    history.ncombin(i)=ncombin;
    logp = logp + log(ptrue);
end