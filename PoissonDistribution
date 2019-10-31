clear all
clc
lambda1 = 1;
lambda2 = 7;
lambda3 = 11;

x(1) = 1;
f1(1) = exp(-lambda1);
F1(1) = f1(1);
f2(1) = exp(-lambda2);
F2(1) = f2(1);
f3(1) = exp(-lambda3);
F3(1) = f3(1);
t(1) = 0;
for i = 1:5
    x(i+1) = x(i)*i;
    f1(i+1) = ((lambda1^i)*exp(-lambda1))/x(i+1);
    F1(i+1) = F1(i) + f1(i+1);
    f2(i+1) = ((lambda2^i)*exp(-lambda2))/x(i+1);
    F2(i+1) = F2(i) + f2(i+1);
    f3(i+1) = ((lambda3^i)*exp(-lambda3))/x(i+1);
    F3(i+1) = F3(i) + f3(i+1);
    t(i+1) = t(i) + 1;
end
ax1 = subplot(2,1,1);
plot(ax1,t,f1,'b',t,f2,'r',t,f3,'g')
legend(ax1,'pmf lambda = 1','pdf lambda = 7','pdf lambda = 11')
title(ax1,'pmf Poisson Distribution')
ax2 = subplot(2,1,2);
plot(ax2,t,F1,'b',t,F2,'r',t,F3,'g')
legend(ax2,'cdf lambda = 1','cdf lambda = 7','cdf lambda = 11')
title(ax2,'cdf Poisson Distribution')
