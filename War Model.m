close all
clear all
clc

A(1) = 1143000; % USSR
B(1) = 1040000; % NAZI
alpha = 184000; % USSR
beta = 104000; % NAZI
t(1) = 0;
waktu(1) = 0;
for i = 1:7*30
    A(i+1) = A(i) - beta*B(i)/A(i);
    B(i+1) = B(i) - alpha*A(i)/B(i);
    if B(i)>A(i)
        waktu(i) = t(i);
    end
    t(i+1) = t(i) + 1;
end
plot(t,A,'r',t,B,'k')
legend('USSR','NAZI')
