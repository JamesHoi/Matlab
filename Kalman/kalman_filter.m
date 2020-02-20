function kalman_filter = kalman_filter(num) %#ok<*STOUT>
%------------------------------Help----------------------------------------
% The function is kalman_filter(num) (the total number for testing is num)
% And this function is for testing the kalman filter
% Reference:https://wenku.baidu.com/view/de35fd1ca8114431b90dd845.html
%--------------------------------------------------------------------------

%-----------------------------Initialize-----------------------------------
%Setting
limit_noice = 1; % so the error is 25
%which small,which side
Estimate_proportion = 0.02;
Sensor_proportion = 0.7;

%Input
Sensor_random = rand(1,num)*limit_noice % A random noice for testing
%Sensor_normal_distribution = 
Sensor_value = Sensor_random;
Last_value = Sensor_value(1);

%Iteration needed
Kg = 0; % A proportion for the error between optimum value
Gaussian_error = 0; % The Gaussian noice error
Estimate_error = limit_noice*Estimate_proportion; % The error for Estimate (If it smaller,the Filter value can be more stable)
Sensor_error = limit_noice*Sensor_proportion; % test the Sensor_error to 20
Last_error = 0; % Last Estimate_error

%Output
Filter_value = 0;
%--------------------------------------------------------------------------

%------------------------------Start Filter--------------------------------
for i = 1:num
   Gaussian_error = sqrt(Last_error^2+Estimate_error^2);
   Kg = sqrt(Gaussian_error^2/(Gaussian_error^2+Sensor_error^2));
   Filter_value(i) = Last_value+Kg*(Sensor_value(i)-Last_value);
   Last_error = sqrt((1-Kg)*Gaussian_error^2);
   Last_value = Filter_value(i);
end
%--------------------------------------------------------------------------

%---------------------------------End-------------------------------------
x = 1:1:num;
y_filter = Filter_value(x);
y_sensor = Sensor_value(x);
plot(x,y_filter,'-g',x,y_sensor,'-k')
end
%--------------------------------------------------------------------------