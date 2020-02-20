%% 初始化
clear;
g = 9.8;

%% 最小二乘法數據擬合
%{
load('x_back.mat');
f=@(a,x)(a(1)*x(1,:)+a(2)).^2 + (a(3)*x(2,:)+a(4)).^2 + (a(5)*x(3,:)+a(6)).^2;

ran1_min = 0; ran1_max = 1.02;
ran2_min = -60; ran2_max = 60;
minimum = 0.9; maximum = 100000;
scale_max = 1.16;
e = 1000000;
A = [1i,0,0,0,0,0];
%init = [-0.509443081061597,1.130517394567094,0.768192745168030,-0.156064996835810,1.427063331493108,-1.797383757555508];
options = optimset('MaxFunEvals',9);
k = 0;
toosmall = 0;
while((~isreal(A(1))||max(max(A))>=maximum||abs(min(min(A)))>=maximum||isequal(A,init)||toosmall))%||resnorm>e)
    toosmall = 0;
    init1 = ran1_min + (ran1_max-ran1_min).*rand([1 3]);
    init2 = ran2_min + (ran2_max-ran2_min).*rand([1 3]);
    init = [init1(1),init2(1),init1(2),init2(2),init1(3),init2(3)];%-3.4];
    init = [0.988873722393835,78.116119620635710,0.989409528557404,77.883856808381760,1.052428944765637,20.758010149953480];
    %使用lsqcurvefit
    [A,resnorm] = lsqcurvefit(f,init,[ax;ay;az],g^2*ones(1,length(ax)),[],[],options);
    while(1+2*k<=5)
       if(abs(A(1+2*k))<minimum||A(1+2*k)<0||A(1+2*k)>scale_max)
           toosmall = toosmall|1;
       end
       k = k+1;
    end
    k = 0;
end
%A = [1.084088938032716,1.033457202589558e+02,1.124128155036683,-43.393976345096185,1.360265657026317,-5.043206468517507e+02];
figure(1);
plot(((A(1)*ax+A(2))/4096)*9.8,'r');
hold on
plot((ax/4096)*9.8,'b');
hold on
ylabel('X');

figure(2);
plot(((A(3)*ay+A(4))/4096)*9.8,'r');
hold on
plot((ay/4096)*9.8,'b');
hold on
ylabel('Y');

figure(3);
plot(((A(5)*az+A(6))/4096)*9.8,'r');
hold on
plot((az/4096)*9.8,'b');
hold on
ylabel('Z');
%}


%% 橢球擬合
%{
load('data.mat');
data = [ax;ay;az];
[Center,Scale_axis] = fit_elliposoid9(data);

function[ Center,Scale_axis] = fit_elliposoid9( data )
% input data is n*3,  n points of the ellipsoid surface
% Least Square Method
%  a(1)x^2+a(2)y^2+a(3)z^2+a(4)xy+a(5)xz+a(6)yz+a(7)x+a(8)y+a(9)z=1
% output Center is 1*3, center of elliposoid, 
% Scale_axis is 1*3, 3 axis' scale
% author  Zhang Xin

data_s = 1000;
data_e = 2000;
x=data(1,data_s:data_e);
y=data(2,data_s:data_e);
z=data(3,data_s:data_e);
               
D=[x.*x y.*y z.*z x.*y x.*z y.*z x y z ];
a=pinv(D'*D)*D'*ones(size(x));
M=[a(1) a(4)/2 a(5)/2;...
   a(4)/2 a(2) a(6)/2;...
   a(5)/2 a(6)/2 a(3)]; 
Center=-1/2*[a(7),a(8),a(9)]/M;  
SS=Center*M*Center'+1;
[U,V]=eig(M);
[~,n1]=max(abs(U(:,1)));
[~,n2]=max(abs(U(:,2)));
[~,n3]=max(abs(U(:,3)));
lambda(n1)=V(1,1);
lambda(n2)=V(2,2);
lambda(n3)=V(3,3);
Scale_axis=[sqrt(SS/lambda(1)),sqrt(SS/lambda(2)),sqrt(SS/lambda(3))];        
Center=round(Center);
Scale_axis=round(Scale_axis);

figure
plot3(x,y,z,'b.',Center(1),Center(2),Center(3),'ro');
axis equal
xlabel('X');
ylabel('Y');
zlabel('Z');

end
%}

%% 減偏移後計算矩陣
%offset
%%{
x_front = load('x_degree_front.mat','ax','ay','az');
x_back = load("x_degree_back.mat",'ax','ay','az');
y_front = load('y_degree_front.mat','ax','ay','az');
y_back = load('y_degree_back.mat','ax','ay','az');
z_front = load('z_degree_front.mat','ax','ay','az');
z_back = load('z_degree_back.mat','ax','ay','az');

x_offset = (median(x_front.ax)+median(x_back.ax))/2;
y_offset = (median(y_front.ay)+median(y_back.ay))/2;
z_offset = (median(z_front.az)+median(z_back.az))/2;

x_gain = 0.5*((median(x_front.ax)-median(x_back.ax))/g);
y_gain = 0.5*((median(y_front.ay)-median(y_back.ay))/g);
z_gain = 0.5*((median(z_front.az)-median(z_back.az))/g);

index = 3;

G = [g,0,0;
     0,g,0; 
     0,0,g];

X = [x_front.ax(index)-x_offset,x_front.ay(index)-y_offset,x_front.az(index)-z_offset;
     y_front.ax(index)-x_offset,y_front.ay(index)-y_offset,y_front.az(index)-z_offset;
     z_front.ax(index)-x_offset,z_front.ay(index)-y_offset,z_front.az(index)-z_offset];
     
R = G*inv(X);
%}

%% fit函數
%{
load('data.mat');
x_offset = 34.75;
y_offset = 38.25;
z_offset = 1467;
scatter3(ax-x_offset,ay-y_offset,az-z_offset,'k');
%sf = fit([ax',ay'],az','poly23')
%plot(sf,[ax',ay'],az')
%}

%% 對比
%{
load('x_front.mat');
%A = [1.084088938032716,1.033457202589558e+02,1.124128155036683,-43.393976345096185,1.360265657026317,-5.043206468517507e+02];
%R = [1.000006076342598,0.015886968119414,0.011363179423662;0.002108427027866,1.002516613023095,-0.025495544682056;-0.017648962215782,-0.027665702484660,0.984166129998751];
R = [1.013017765336491,0.021990259448089,-0.006549111766514;-0.019465400207543,1.047961212296067,-0.011126285185497;0.003473633143529,0.080594665067464,1.037774624346102];

k = 1;
%x_offset = 0;%34.75;
%y_offset = 0;%38.25;
%z_offset = 0;%1467;

%{
while(k<=length(ax))
    acc = [ax(k)-x_offset,ay(k)-y_offset,az(k)-z_offset]*R;
    ax_t(k) = acc(1);
    ay_t(k) = acc(2);
    az_t(k) = acc(3);
    k = k+1;
end
%}

%{
figure(1)
scatter3(ax_t,ay_t,az_t,'k');
figure(2)
scatter3(ax,ay,az,'p');
xlabel('X');
ylabel('Y');
zlabel('Z');
%}

%%{
figure(1);
plot((ax_t/4096)*g,'r');
hold on
plot((ax/4096)*g,'b');
hold on
ylabel('X');

figure(2);
plot((ay_t/4096)*g,'r');
hold on
plot((ay/4096)*g,'b');
hold on
ylabel('Y');

figure(3);
plot((az_t/4096)*9.8,'r');
hold on
plot((az/4096)*9.8,'b');
hold on
ylabel('Z');
%}



