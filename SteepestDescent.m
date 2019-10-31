close all
clear all
clc

syms f(x,y) phi(alpha) g(x,y) h(x,y) x y alpha
f(x,y) = 4*x^2 - 4*x*y + 2*y^2;
g(x,y) = diff(f(x,y),x);
h(x,y) = diff(f(x,y),y);
x(1) = -5;
y(1) = 10;
error = 1.0e-6;
maxiter = 25;
t(1) = 0;
for i = 1:maxiter
    if double(x(i)) <= error && double(y(i)) <= error
        break
    else
        phi(alpha) = f(x(i)-alpha*g(x(i),y(i)),y(i)-alpha*h(x(i),y(i)));
        alpha = solve(diff(phi(alpha))==0,alpha);
    end
    x(i+1) = x(i) - alpha*g(x(i),y(i));
    y(i+1) = y(i) - alpha*h(x(i),y(i));
    t(i+1) = t(i) + 1;
    syms phi(alpha)
end

fcontour(@(x,y) 4*x^2 - 4*x*y + 2*y^2, [-10 10 -10 10])
hold on
plot(x,y,'-ob')
title('Stepest-Descent Method')
