close all;
clear;

%Rastrigcn
x1=linspace(-5.12,5.12,100);
x2=x1;
[X1,X2]=meshgrid(x1,x2);
D=2;
X=[X1,X2];
A=X1.^2-10*cos(2*pi*X1);
B=X2.^2-10*cos(2*pi*X2);
Z=10*D+A+B;
Rastrigin = meshc(X1,X2,Z);
colormap('pink')
xlabel('X1')
ylabel('X2')
zlabel('Z')
title('Rastrigin')