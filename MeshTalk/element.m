close all; clear all; clc;
figure(1); hold on; 
x0 = 0; y0 = 0;

linex = x0+[0,1];
liney = y0+[0,0];
plot(linex,liney,'k-o','linewidth',2,'markersize',6,'markerfacecolor','w');

x0 = 1.75;
linex = x0+[0,0.5,1];
liney = y0+[0,  0,0];
plot(linex,liney,'k-o','linewidth',2,'markersize',6,'markerfacecolor','w');

x0 = 0; y0 = -1;
linex = x0+[0,0.5,0.25,0];
liney = y0+[0,  0,0.25*sqrt(3),0];
plot(linex,liney,'k-o','linewidth',2,'markersize',6,'markerfacecolor','w');

x0 = x0+0.75; 
linex = x0+[0, 0.25, 0.5, 0.375,        0.25,           0.125,         0];
liney = y0+[0, 0,    0,   0.125*sqrt(3) 0.25*sqrt(3),   0.125*sqrt(3), 0];
plot(linex,liney,'k-o','linewidth',2,'markersize',6,'markerfacecolor','w');

x0 = x0+0.75; 
linex = x0+[0, 0.5,  0.5,   0,   0];
liney = y0+[0, 0,    0.5,   0.5, 0];
plot(linex,liney,'k-o','linewidth',2,'markersize',6,'markerfacecolor','w');

x0 = x0+0.75; 
linex = x0+[0, 0.25, 0.5,  0.5, 0.5, 0.25,  0,  0,    0];
liney = y0+[0, 0,    0,    0.25,0.5, 0.5,   0.5,0.25, 0];
plot(linex,liney,'k-o','linewidth',2,'markersize',6,'markerfacecolor','w');

x0 = 0; y0 = -2;


axis equal;