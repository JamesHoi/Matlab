function [ax,ay,az,gx,gy,gz] = get_data(testing_time_s,sampling_interval_ms)
%sampling_interval_ms have to be bigger than 50
%get data from stm32

%clear
delete(instrfindall);
%clear;

%errors
if testing_time_s<1
    disp('错误：采集时间不能小于1秒');
    return;
end
if sampling_interval_ms<50
    disp('错误：采集间隔不能小于50毫秒');
    return;
end

%constant
%sampling_interval_ms = 100; %sampling interval millisecond
%testing_time_s = 5; %testing time

%comm initialize
s = serial('com6','BaudRate',115200);
s.BytesAvailableFcnMode='byte';  % 串口设置  
s.InputBufferSize=4096;  
s.OutputBufferSize=1024;  
s.BytesAvailableFcnCount=100;  
s.ReadAsyncMode='continuous';  
s.Terminator='CR';  

%initialize
fopen(s);
Head = ' ';
End = ' ';
i = 1;
j = 1;

%Timer start
start = tic;

while(toc(start)<testing_time_s)
    t0=tic;
    
    %analysing
    while(Head~='S')
        Head = char(fread(s,1,'uint8')');
    end

    while(End~='E')
        End = char(fread(s,1,'uint8')');
        if(End=='E')
            %delete the last character E
            break;
        end
        data(i) = End;
        i = i+1;
    end

    %get data
    gx(j) = str2double(data(3:9));
    gy(j) = str2double(data(12:18));
    gz(j) = str2double(data(21:27));
    ax(j) = str2double(data(30:36));
    ay(j) = str2double(data(39:45));
    az(j) = str2double(data(48:54));
    t(j) = toc(start)*1000;

    %clear
    Head = ' ';
    End = ' ';
    i = 1;
    
    %loop
    j = j+1;
    
    t1 = toc(t0);
    %delay
    if (t1)<0.05
        pause(sampling_interval_ms*0.001-(t1+0.00077));
    end
end

%{
%plot gyro lines
figure(1);
plot(t,gx,'r');
hold on
plot(t,gy,'b');
hold on
plot(t,gz,'g');
xlabel('毫秒/ms');
ylabel('角度/degree');

legend('+X方向','+Y方向','+Z方向');
title('九轴传感器');

%plot accelerator lines
figure(2);
plot(t,ax,'r');
hold on
plot(t,ay,'b');
hold on
plot(t,az,'g');
xlabel('毫秒/ms');
ylabel('加速度m/s^2');
legend('+X方向','+Y方向','+Z方向');
title('九轴传感器');
%}

%clear comm
fclose(s);
delete(s);
clear s;

%save mat
save('data.mat','ax','ay','az','gx','gy','gz','t');

end