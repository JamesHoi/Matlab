function pidcontrol = pidcontrol(Testing_Time) %#ok<*STOUT>
%------------------------------Help----------------------------------------
% The function is pidcontrol(Testing_Time)
% And this program will test only one motor
% Use square root of 2 divided by 2 = 0.7
% References: 
% https://www.zybang.com/question/6bb1067912704a14d88900f35fdbdcd0.html
% https://zhidao.baidu.com/question/121618177.html
%--------------------------------------------------------------------------

%-----------------------------Initialize-----------------------------------
%Setting

%PIDController for speed
PIDController_Kp_Speed = 5; 
PIDController_Ti_Speed = 0; 
PIDController_Td_Speed = 1;
Target_RPM = 120;%A standard RPM of all motor 

%PIDController for distance
PIDController_Kp_Distance = 33; 
PIDController_Ti_Distance = 0; 
PIDController_Td_Distance = 30;
Target_Distance = 2000;%Distance unit is cm

Gear_Ratio = 3;
Wheel_Radius = 5*2;%unit is cm

%When Ti = 0
if PIDController_Ti_Speed==0
   SpeedController_Ki_Speed=0;
else
    SpeedController_Ki_Speed = 1/PIDController_Ti_Speed;
end

if PIDController_Ti_Distance==0
   SpeedController_Ki_Distance=0;
else
    SpeedController_Ki_Distance = 1/PIDController_Ti_Distance;
end

%Some value use in PidControl of Speed
Error_RPM = 0;
Last_Error_RPM = 0;
Output_PWM_Speed = 0;%For Speed Controller 

%Some value use in PidControl of Distance
Error_Distance = 0;
Last_Error_Distance = 0;
Output_PWM_Distance = 0;%For Distance Controller 

%Some Setting for Matlab testing
%warning!!!!!!!!!!!!!!
%This Program counld not change the motor speed
%Because of ¼ÓËÙ±í Refrences:https://zhidao.baidu.com/question/332947719382882685.html
Current_RPM = 120; 
Max_RPM = Target_RPM;

Current_Distance = 0;
Last_Distance = 0;
Voltage_Graph = 0;
Distance_Graph = 0;

Time = 0;
fre = 2;
%--------------------------------------------------------------------------

%-----------------------Start PIDControl of Speed----------------------
%use "for" is for the testing and record for the line graph
for i = 1:Testing_Time
    Error_RPM(i) = Target_RPM-Current_RPM;
    Output_PWM_Speed = (PIDController_Kp_Speed*(Error_RPM(i)+SpeedController_Ki_Speed*sum(Error_RPM)+PIDController_Td_Speed*(Error_RPM(i)-Last_Error_RPM)))/Target_RPM;
    Voltage_Graph(i) = Output_PWM_Speed;
    Last_Error_RPM = Error_RPM(i);
end 
%--------------------------------------------------------------------------

%-----------------------Start PIDControl of Distance--------------------
while(Testing_Time>=Time(length(Time)))
    i = fre;
    tic;
    Error_Distance(i) = Target_Distance-Current_Distance;
    Output_PWM_Distance = (PIDController_Kp_Distance*(Error_Distance(i)+SpeedController_Ki_Distance*sum(Error_Distance)+PIDController_Td_Distance*(Error_Distance(i)-Last_Error_Distance)))/Target_Distance;
    Distance_Graph(i) = Wheel_Radius*pi*Output_PWM_Distance*Max_RPM*Gear_Ratio*toc/60+Last_Distance;
    Current_Distance = Distance_Graph(i);
    Last_Distance = Distance_Graph(i);
    Last_Error_Distance = Error_Distance(i);
    Time(i) = Time(i-1)+toc;
    fre = fre+1;
end 
%--------------------------------------------------------------------------

%---------------------------------End-------------------------------------
x = 1:1:Testing_Time;
y_voltage = Voltage_Graph(x);
plot(x,y_voltage)
plot(Time,Distance_Graph,'-r','LineWidth',0.01);
end
%--------------------------------------------------------------------------