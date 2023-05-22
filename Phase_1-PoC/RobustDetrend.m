function [polorder,detrenddata,trend] = RobustDetrend(data,n,conflvl,samplepts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate the best order of robust polynomial regression that detrend the%
% data and detrend (use wdenoise to denoise data before processing)       %
%                                                                         %
% input :                                                                 %
% data = data to detrend                                                  %
% n = polynome order limit                                                %
% conflvl = percentage confidence for over the null hypothesis that       %
% coefficients are null 0.975 for 97,5% confidence                        %
% samplepts = specify sample points                                       %
%                                                                         %
% output :                                                                %
% polorder : polynome order of trend                                      %
% detrenddata : detrended data                                            %
% trend : the trend estimate                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 1
    n = min(length(data),6);
    conflvl = 0.975;
elseif nargin == 2
    conflvl = 0.975;
end
warning('off','stats:statrobustfit:IterationLimit');
if nargin < 4
    x = (1:length(data))';
else
    if size(samplepts,2) == 1
        x = samplepts;
    elseif size(samplepts,1) == 1
        x = samplepts';
    end
end
x = (x-mean(x))./std(x);
if size(data,2) == 1
    y = wdenoise(data);
elseif size(data,1) == 1
    y = wdenoise(data');
end
y = (y-mean(y))./std(y);
[~,stats] = robustfit(x,y,'bisquare');
test = stats.p(2) < (1-conflvl);
if test
    polorder = 1;
    X(:,1) = x;
    while (test)&&(polorder < n)
        polorder = polorder+1;
        X(:,polorder) = x.*X(:,polorder-1);
        [~,stats] = robustfit(X,y,'bisquare');
        test = all(stats.p(2:polorder+1) < (1-conflvl)/polorder);
    end
    if polorder < n
        polorder = polorder-1;
    end
else
    polorder = 0;
end
if polorder ~= 0
    X = X(:,1:polorder);
    pr = robustfit(X,data,'bisquare');
    trend = polyval(pr(end:-1:1),x);
    detrenddata = data-trend;
else
    pr = robustfit(x,data,'bisquare');
    trend = pr(1);
    detrenddata = data-trend;
end
end