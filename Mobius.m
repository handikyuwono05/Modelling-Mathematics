close all
clear all
clc

s = linspace(-1,1);
t = linspace(0,2*pi);
[s,t] = meshgrid(s,t);
x = (1+s.*cos(t/2)).*cos(t);
y = (1+s.*cos(t/2)).*sin(t);
z = s.*sin(t/2);

surf(x,y,z)
