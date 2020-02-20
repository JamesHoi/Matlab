function gauss2uniform = gauss2uniform(Testing_Time) %#ok<*STOUT>

gauss = zeros(1,Testing_Time)

for i = 1:Testing_Time
    z0=normrnd(0,2);
    z1=normrnd(0,2);
    if z1~=0 
        gauss(i) = atan(z0/z1)/(2*pi)+0.5;
    end
end
hist(gauss);

