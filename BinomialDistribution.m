clc
clear all
close all

n = 20
p = 0.5
binom = 1
kumulatif = 1
x1 = [0:20]
y1(1) = (1-p)^20
y2(1) = (1-p)^20

for i = 1:20
    x = i
    binom = binom / (i) * (n-1+i)
    y1(i+1) = binom * (p^x) * (1-p)^(n-x)
    y2(i+1) = y2(i) + y1(i+1)
end

plot(x1, y1, x1, y2)
title('Peluang Binomial')
xlabel('x')
ylabel('P(X) = x')
axis([0 20 0 1])
