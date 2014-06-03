function [ Avg ] = ExactChrom(Req, Desired )
%EXACTCHROM compute average number of chroms needed
%Req = [ReqStr, ReqDex, ReqInt]
%Desired =[1,1,2,3,3] a 1 for R, 2 for G, 3 for B repeated as many times as
%   you want that socket
%Example RRBBB a Lightning Coil (96 Str, 96 Dex) req
%   ExactChrom([96,96,0],[1,1,3,3,3])

Desired=sort(Desired);

%Compute probability of a socket being a particular color independtly
%   lawphil's X
%Xlp=15;
Xlp = 12;

P = normalize(Req+Xlp,2);
Pr = P(1);
Pg = P(2);
Pb = P(3);

% Compute Possible Configurations
N = numel(Desired);
Nfact = factorial(N);

Comb = nchoosek([ones(1,N),2*ones(1,N),3*ones(1,N)],N);
Comb = unique(Comb,'rows');
Nc = size(Comb,1);
PComb=nan(1,Nc);

%Compute the probability of each possible configuration
ind = -1;
for i=1:Nc
    if all(Comb(i,:)==Desired)
        ind=i;
    end
    Nr=(numel(find(Comb(i,:)==1)));
    Ng=(numel(find(Comb(i,:)==2)));
    Nb=(numel(find(Comb(i,:)==3)));
    assert(N==Nr+Ng+Nb);
    PComb(i) = Nfact/(factorial(Nr)*factorial(Ng)*factorial(Nb))*Pr^Nr*Pg^Ng*Pb^Nb;
end

%Create the markov transition matrix
T = repmat(PComb,Nc,1);
for i=1:Nc
    T(i,i)=0;
end
T = normalize(T,2);
T(ind,:)=zeros(1,Nc);
T(ind,ind)=1;

%Compute the fundamental matrix for absorbing markov chains
%   notation from: http://en.wikipedia.org/wiki/Absorbing_Markov_chain
Q = T(1:Nc~=ind,1:Nc~=ind);
N = inv(eye(Nc-1)-Q);
Avg=mean(sum(N));

end

function [ X ] = normalize( X,dim )
if nargin<2
    dim=1;
end

if dim==2
    n=size(X,1);
    Xs=sum(X,2);
    X= sparse(1:n,1:n,1./Xs)*X;

elseif dim==1
    n=size(X,2);
    Xs=sum(X,1);
    X= X*sparse(1:n,1:n,1./Xs);
end

end