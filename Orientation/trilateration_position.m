% ----------------采用三边定位法对未知节点定位-------------------------------

%{
    clc命令是用来清除命令窗口的内容。不管开启多少个应用程序，命令窗口只有一个，
    所以clc无论是在脚本m文件或者函数m文件调用时，clc命令都会清除命令窗口的内容。

    clear命令可以用来清除工作空间的内容。MATLAB有个基本的工作空间，用base标识，
    此外，当打开一个函数m文件时，可能会产生很多工作空间。每一个函数对应一个工作空间。
%}
clear;

maxx = 1000;%参考节点分布的最大横坐标
maxy = 1000;%参考节点分布的最大纵坐标

%----------------------随机初始化三个已知的参考点[cx,cy]-----------------
%{
    rand()产生0和1之间均匀分布的随机数
    rand(m)产生一个m*m的矩阵，当然矩阵的值是0和1之间均匀分布的随机数
    rand(m,n)或者rand([m,n])产生一个m*n的矩阵
    randn()产生均值为0, 方差为1的正态分布的随机数。用法和rand类似。
%}
cx = maxx*rand(1,3);
cy = maxy*rand(1,3);
plot(cx,cy,'k^');%参考节点图

%--------随机初始化一个未知节点（mx,my）-----------
mx = maxx*rand();
my = maxy*rand();
hold on;
% 盲节点图
plot(mx,my,'go'); 

da = sqrt((mx-cx(1))^2+(my-cy(1))^2);
db = sqrt((mx-cx(2))^2+(my-cy(2))^2);
dc = sqrt((mx-cx(3))^2+(my-cy(3))^2);

% 计算定位坐标
[locx,locy] = triposition(cx(1),cy(1),da,cx(2),cy(2),db,cx(3),cy(3),dc);      
plot(locx,locy,'r*');
legend('參考節點','盲節點','定位節點','Location','SouthEast');  
title('三邊測量法的定位');

derror = sqrt((locx-mx)^2 + (locy-my)^2);
disp(derror);