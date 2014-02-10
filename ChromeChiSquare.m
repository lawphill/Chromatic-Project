%% Calculate chi-square GoF for observed Chromatic rolls
% Simulated rolls are used to determine expected frequencies

% Chi-square for sums of each color type
O = h1;
E = hist_exp;

% condense 4-6 of a color into one row
O(5,:) = sum(O(5:7,:)); O(6:7,:)=[];
E(5,:) = sum(E(5:7,:)); E(6:7,:)=[];

smoothing = .000001; % No expected value can be exactly 0

nulls = find(E==0);
E(nulls) = smoothing;

chi2hist = sum(sum((O-E).^2 ./ E));
s = size(E);
dfhist = (s(1)-1)*(s(2)-1);

phist = chi2pdf(chi2hist,dfhist);

% calculate Yates correction

chi2Yates = sum(sum((abs(O-E)-.5) .^ 2 ./ E));

pYates = chi2pdf(chi2Yates,dfhist);

clearvars nulls;

% Chi-square for total sum of each color
% i.e. O = [#R,#G,#B] E = [#R,#G,#B]

sumsO = sum(data(:,7:9));
sumsE = sums_exp/sum(sums_exp) * sum(sum(data(:,7:9)));

chi2sums = sum(sum((sumsO-sumsE).^2 ./ sumsE));
dfsums = sum(size(sumsE)) - 2;

psums = chi2pdf(chi2sums,dfsums);

% Chi-square for pure color, 2 colors, 3 colors

zerosO = data(:,7:9)==0;
totalsO = sum(zerosO')';

colorsO = [length(find(totalsO==2)) length(find(totalsO==1)) ...
    length(find(totalsO==0))];
colorsE = colors_exp;
colorsE = colorsE / sum(colorsE) * sum(colorsO);


chi2colors = sum(sum((colorsO-colorsE).^2 ./ colorsE));
dfcolors = sum(size(colorsE)) - 2;

pcolors = chi2pdf(chi2colors,dfcolors);

% Put all relevant info in single datastruct

p.phist = phist;
p.pYates = pYates;
p.psums = psums;
p.pcolors = pcolors;
p.chi2Yates = chi2Yates;
p.chi2hist = chi2hist;
p.chi2sums = chi2sums;
p.chi2colors = chi2colors;
p.dfhist = dfhist;
p.dfYates = dfhist;
p.dfsums = dfsums;
p.dfcolors = dfcolors;

hists.Oall = h1;
hists.Eall = hist_exp;
hists.O = O;
hists.E = E;
hists.Ocolors = colorsO;
hists.Ecolors = colorsE;
hists.Osums = sumsO;
hists.Esums = sumsE;

clearvars phist pYates psums pcolors chi2Yates chi2hist chi2sums chi2colors;
clearvars dfhist dfsums dfcolors;