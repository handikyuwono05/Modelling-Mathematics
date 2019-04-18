clear variables
close all
clc
%%Program yang disusun untuk menaksir ketinggian air di bawah pintu air
%menggunakan metode Direct Step dan persamaan Saint-Venant
% Deklarasi variabel
global length step Q beta grav b m n sl Hc Hn;
length = 5050; % Panjang sungai (dalam m)
step = 1; % Panjang step yang dihitung
Q = 75.; % Fluks sungai
beta = 1.; % Faktor koreksi
grav = 9.8; % Percepatan gravitasi
b = 20; % Lebar dasar sungai
m = 0.33; % Kemiringan dinding sungai
n = 0.015; % Manning friction constant
i = 1; % Variabel counter untuk ketinggian air
Z(i) = 10.; % Ketinggian tanah dari garis datum/tumpu
H(i) = 1.5; % Ketinggian air awal dihitung dari dasar sungai
sl = -0.001; % Kenaikan ketinggian tanah antar step. Negatif
artinya turun.
Hc = 1.121; % Untuk sementara input langsung nilainya dari
kalkulator di net
Hn = 1.218; % Idem di atas
VecHc(i) = Hc + Z(i);
VecHn(i) = Hn + Z(i);
for j = step: step: length
i = i+1;
Z(i) = Z(i-1) + sl;
VecHc(i) = VecHc(i-1) + sl;
VecHn(i) = VecHn(i-1) + sl;
H(i) = RegFals(H(i-1), Z(i-1), Z(i));
end
% Plotting hasil
x = 0:step:length;
figure(1)
plot(x,H+Z,x,Z) % Plot profil permukaan air
hold on
plot(x,VecHc,'-.k') % Plot CDL
plot(x,VecHn,'--') % Plot NDL
hold off

function Hbaru = RegFals(H, Z, Z1)
global beta grav Q step n Hc Hn
f = @(H1) Z1 + H1 - Z - H + beta*Q^2 /(2*grav) *(1/A(H1)^2 -
1/A(H)^2)...
+ ((step/2)*n^2*Q^2 *((1/(A(H)^2 * power(R(H),4/3))) + (1/(A(H1)^2 *
R(H1)^(4/3)))));
a = Hc; u = 1.2*H; % Tebakan awal
eps = 1E-10;
%Pengecekan tebakan awal
FA = f(a); FB = f(u);
if FA*FB >=0
error('Tebakan awal tidak valid.')
end
%Deklarasi variabel pendukung
CLama = 2*u - a;
Lcount = 0; Rcount = 0;
iter = 50;
%Proses pencarian akar
for j = 1:iter
c = a - FA*(u-a)/(FB-FA);
FC = f(c);
if abs(FC) < eps
akar = c;
break
end
if FA * FC < 0
u = c; FB = FC;
Lcount = Lcount + 1; Rcount = 0;
if Lcount > 2
FA = FA / 2;
end
else
a = c; FA = FC;
Lcount = 0; Rcount = Rcount + 1;
if Rcount > 2
FB = FB / 2;
end
end
%Pengecekan galat pada akar
if abs(c - CLama) < eps
akar = c;
break
end
CLama = c;
end
if isempty(akar)
error('Akar tidak ditemukan')
else
Hbaru = akar;
end
end

function Area = A(H)
global b m
Area = H*(b + m*H);
End
function WetPerim = P(H)
global b m
WetPerim = b + 2*H*sqrt(1+m^2);
end
function Hydraulic = R(H)
Hydraulic = A(H)/P(H);
end
