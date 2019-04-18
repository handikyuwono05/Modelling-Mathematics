N = [1:32]; % Vektor Nurse dengan total 32 Nurse
H = [1:14]; % Vektor Hari dengan total 14 Hari
S = [1:3]; % Vektor Shift dengan total 3 Shift (d,e,n)
% Kendala 1 : Dalam satu hari sseorang perawat hanya bekerja satu shift
A1 = zeros(length(N)*length(H),length(N)*length(H)*length(S));
for i = 1:length(N)
for j = 1:length(H)
for k = 1:length(S)
n = length(H)*length(S)*(i-1)+length(S)*(j-1)+k;
m = length(H)*(i-1)+j;
A1(m,n) = 1;
end
end
end
%Kendala 2 : Setiap shift harus dilayani satu grup perawat (4 orang)
A2 = zeros(length(H)*length(S),length(N)*length(H)*length(S));
for j = 1:length(H)
for k = 1:length(S)
for i = 1:length(N)
n = length(H)*length(S)*(i-1)+length(S)*(j-1)+k;
m = length(S)*(j-1)+k;
A2(m,n) = 1;
end
end
end

% Jika seorang perawat ditugaskan pada shift malam, mk dia tidak boleh
% ditugaskan pada shift pagi di hari berikutnya
A3 = zeros(length(N)*(length(H)-1),length(N)*length(H)*length(S));
A3(1,3) = 1;
for i = 1:length(N)
for j = 1:length(H)-1
for k = 1:length(S)
n = length(H)*length(S)*(i-1)+length(S)*j+k;
m = (length(H)-1)*(i-1)+j;
A3(m,n) = 1;
if k == length(S) && m ~= length(N)*(length(H)-1)
A3(m+1,n)=1;
end
end
end
end
%Kendala 4 : Jika seorang perawat ditugaskan dalam tiga hari berturutturut
%maka hari keempatnya dia tidak boleh ditugaskan.
A4 = zeros(length(N)*(length(H)-3),length(N)*length(H)*length(S));
for i = 1:length(N)
for j = 1:length(H)-3
for k = 1:length(S)
n = length(H)*length(S)*(i-1)+length(S)*(j-1)+k;
m = length(N)*(j-1)+i;
A4(m,n) = 1;
A4(m,n+3) = 1;
A4(m,n+6) = 1;
A4(m,n+9) = 1;
end
end
end
%Kendala 5 Jika seorang perawat ditugaskan pada suatu weekend
(Sabtu/Minggu) maka dia
%tidak boleh ditugaskan pada weekend berikutnya
A51 = zeros(length(N),length(N)*length(H)*length(S));
for i = 1:length(N)
for k = 1:length(S)
n = length(H)*length(S)*(i-1)+k+15;
m = i;
A51(m,n) = 1;
n = length(H)*length(S)*(i-1)+k+36;
A51(m,n) = 1;
end
end
A52 = zeros(length(N),length(N)*length(H)*length(S));
for i = 1:length(N)
for k = 1:length(S)
n = length(H)*length(S)*(i-1)+k+15;
m = i;
A52(m,n) = 1;
n = length(H)*length(S)*(i-1)+k+39;
A52(m,n) = 1;
end
end

A53 = zeros(length(N),length(N)*length(H)*length(S));
for i = 1:length(N)
for k = 1:length(S)
n = length(H)*length(S)*(i-1)+k+18;
m = i;
A53(m,n) = 1;
n = length(H)*length(S)*(i-1)+k+36;
A53(m,n) = 1;
end
end
A54 = zeros(length(N),length(N)*length(H)*length(S));
for i = 1:length(N)
for k = 1:length(S)
n = length(H)*length(S)*(i-1)+k+18;
m = i;
A54(m,n) = 1;
n = length(H)*length(S)*(i-1)+k+39;
A54(m,n) = 1;
end
end
A5 = [A51;A52;A53;A54];
A = [A1;A3;A4;A5];
Aeq = A2;
b1 = ones(length(N)*length(H),1);
beq = 4*ones(length(H)*(length(S)),1);
b3 = ones(length(N)*(length(H)-1),1);
b4 = 3*ones(length(N)*(length(H)-3),1);
b5 = ones(4*length(N),1);
b = [b1;b3;b4;b5];
% Fungsi Objektif
f = ones(length(N)*length(H)*length(S),1);
intcon = [1:length(N)*length(H)*length(S)];
lb = zeros(length(N)*length(H)*length(S),1);
ub = ones(length(N)*length(H)*length(S),1);
x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);
% Transformasi dari x ke J yang merupakan representasi dari jadwal nurse
J = zeros(length(N),length(H)*length(S));
for i = 1:length(N)
for p = 1:length(H)*length(S)
J(i,p)=x(length(H)*length(S)*(i-1)+p);
end
end
% Output merupakan jadwal dari 32 Nurse
J
