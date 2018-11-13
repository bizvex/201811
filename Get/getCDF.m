function [ range,output ] = getCDF( input )
min_ = floor(min(input));
max_ = ceil(max(input));
range = min_:1:max_;
h = hist(input,range);
output = cumsum(h)/sum(h);
end

