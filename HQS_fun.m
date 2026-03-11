function Null = HQS_fun(C)
%HQS function
%   Returns null "Corr" matrices which respect the distribution of the
%   psuedo correlation matrix C.  f_ij sampled from truncated normal dist
%   C--observed PSD matrix
%   M--number of null networks desired
%   CC--transform elements of C:  log(cij/(1-cij)) in (-Inf,Inf)
C = (C+C')/2;
% eps = 1e-12;
% C=log(C./(1-C));
% 
% %for computational ease...
% neg=-12+(-13+12)*rand(1); pos=12+(13-12)*rand(1);
% C(C>=12)=pos; %random number between 9 and 10...
% C(C<=-12)=neg; %random number between -10 and -9...

N=size(C,2);
e=sum(C(eye(N)==0))/(N*(N-1));
if e<0
disp('e<0 warning')
else
end
e=max(e,0);
D1=C(eye(N)==0);
v=var(D1); %variance of off diagonal elements
ebar=trace(C)/N;%diagonal mean

m=max(2,floor((ebar^2-e^2)/v));
Mu=max(sqrt(e/m),0);
sigsq=-Mu^2+sqrt(Mu^4+(v/m));

X = normrnd(Mu,sigsq,[size(C,1) m]);
XX = X*X';
Null = XX; 
% Null = exp(XX)./(1+exp(XX));
