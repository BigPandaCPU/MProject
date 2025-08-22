
clear;clc;close all
figure
t = 0:0.002:1.0;
f1=5;
A1 = 10;

f2=25;
A2 = 10;
y1 = A1*sin(2*pi*f1*t);
y2 = A2*sin(2*pi*f2*t);
Y1 = y1+y2;
subplot(1,2,1)
plot(Y1,t)
set(gca, 'YDir','reverse')

A3 = -8.0*t+A2;
y3 = sin(2*pi*f2*t).*A3;
Y3 = y1+y3;
subplot(1,2,2)
plot(Y3,t)
set(gca, 'YDir','reverse')

% % 上半部分直线
% x1=-10:0.2:10;
% y1=0*x1+5;
% 
% % 右半圆
% theta=pi/2:-0.04:-pi/2;
% x2=5*cos(theta)+10;
% y2=5*sin(theta);
% 
% % 下半部分直线
% x3=10:-0.2:-10;
% y3=0*x3-5;
% 
% % 左半圆
% theta=3*pi/2:-0.04:pi/2;
% x4=5*cos(theta)-10;
% y4=5*sin(theta);
% 
% % 一整圈轨迹曲线
% x=[x1 x2 x3 x4];
% y=[y1 y2 y3 y4];
% 
% % 两整圈轨迹曲线
% x=[x x];
% y=[y y];
% 
% % 绘制两整圈轨迹曲线
% figure
% set(gcf,'units','normalized','position',[0.2 0.2 0.6 0.6]);  % 设置 figure 窗口的位置和尺寸
% plot(x,y)
% axis([-16,16,-6,6])
% axis equal
% hold on
% 
% % 分别定义三个运动员的奔跑速度, 使用动画, 实时更新各个运动员的位置
% for i=1:5:length(x)
%     if i ~= 1
%         delete(h1)
%         delete(h2)
%         delete(h3)
%     end
%     k1=fix(1.1*i);      % 定义第一个运动员的速度, 并计算其当前的位置
%     if k1>length(x)
%         k1=length(x);
%     end
%     h1=plot(x(k1),y(k1),'Color',[1 0 0],'Marker','o','LineWidth',5);   % 显示第一个运动员当前的位置
%     
%     k2=fix(1.2*i);      % 定义第二个运动员的速度, 并计算其当前的位置
%     if k2>length(x)
%         k2=length(x);
%     end
%     h2=plot(x(k2),y(k2),'Color',[k2/length(x) 0 k2/length(x)],'Marker','s','LineWidth',5);   % 显示第二个运动员当前的位置
%     
%     k3=fix(1.3*i);      % 定义第三个运动员的速度, 并计算其当前的位置
%     if k3>length(x)
%         k3=length(x);
%     end
%     h3=plot(x(k3),y(k3),'Color',[rand rand rand],'Marker','v','LineWidth',5);   % 显示第三个运动员当前的位置
%     pause(0.1);
% end
