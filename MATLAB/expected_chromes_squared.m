%% Create a sample of chromatic results, based off the current data
% so that we can compare against the actual results

X = round(mean(d.X(:))); % if we think X is some integer value
%X = mean(d.X); % if we think X is some rational value

% Grab information about data
stats = data(:,1:3);
oldcolors = data(:,4:6);

% Initialize data structures
hist_exp = zeros(7,3);
sums_exp = zeros(1,3);
colors_exp = zeros(1,3);

for i = 1:length(stats)
    [combs, psums] = chromatic_squared(oldcolors(i,:),stats(i,:),X);
    
    % Determine number of sockets for each color    
    for j = 1:7
        [xind, yind] = find(combs == j-1);
        for k = 1:length(xind)
            hist_exp(j,yind(k)) = hist_exp(j,yind(k)) + psums(xind(k));
        end
    end
    % Determine the total sum of each color of sockets
    p_color = zeros(length(combs),3);
    for j = 1:length(combs)
        p_color(j,:) = combs(j,:) * psums(j);
    end
    
    sums_exp = sums_exp + sum(p_color);
    
    % Determine the expected number of unique colors
    poss_colors = 3-sum(combs==0,2);
    for j=1:3
        colors_exp(j) = colors_exp(j) + sum(psums(poss_colors==j));
    end
    
    clearvars j poss_colors p_color xind yind k;
end

% Create histograms
figure;
h1 = hist(data(:,7:9),7); 
find_zeros = find(sum(h1,2)==0);
for i = 0:length(find_zeros)
    if i ~= 0
        h1(find_zeros(i),:) = []; % remove line
    end
end
for i = 0:length(find_zeros)
    if i ~= 0
        h1(end+1,:) = [0 0 0];
    end
end
b1 = bar(0:6,h1);
title(gca,'Distribution of Actual Data');

children = get(b1,'Children');
for i = 1:3
    color = [0 0 0];
    color(i) = 1;
    set(children{i},'FaceColor',color);
end
xlabel('Total number of sockets for each color');

figure;
b2 = bar(0:6,hist_exp);
set(gca,'ylim',[0 1000]);
title(gca,'Simulated Distribution');

children = get(b2,'Children');
for i = 1:3
    color = [0 0 0];
    color(i) = 1;
    set(children{i},'FaceColor',color);
end
xlabel('Total number of sockets for each color');

clearvars X alpha children color count find_zeros i line newX r;