clc
clear all
close all

n=20;
EVAPORATE=0.001;
DIFUSI=0.005;
THRESHOLD = 0.8;

sarang = randi([2,21],1,2); %letak sarang
makanan = randi([2,21],1,2); %letak sumber makanan
r = @(x,y) sqrt(sum((x-y).^2));
jarak = r(sarang,makanan);
% asumsi jarak antara sarang dengan sumber makanan tidak kurang dari 4 satuan
% dan tidak lebih dari 20 satuan
while jarak < 4 || jarak > 20
    sarang = randi([2,21],1,2); %letak sarang
    makanan = randi([2,21],1,2); %letak sumber makanan
    jarak = r(sarang,makanan);
end
% nilai nest grid
% sarang terdapat di sel (sarang(1), sarang(2))
for i=2:n+1
    for j=2:n+1
        if i==sarang(1,1) && j==sarang(1,2)
            nestGrid(i,j) = 2;
        else
            nestGrid(i,j) = 1/(abs(i-sarang(1,1))+abs(j-sarang(1,2)));
        end
    end
end

% nilai round food grid
% makanan terdapat di sel (makanan(1),makanan(2))
for i=2:n+1
    for j=2:n+1
        if i==makanan(1,1) && j==makanan(1,2)
            roundFoodGrid(i,j) = 2;
        else
            roundFoodGrid(i,j) = 1/(abs(i-makanan(1,1))+abs(j-makanan(1,2)));
        end
    end
end

for k=1:10
    antGrid=zeros(n+2,n+2,3); %elemen ke-1: nomor semut, ke-2: arah, ke-3: bawa makanan / tidak
    pherGrid=zeros(n+2,n+2); %jumlah pheromone
   
    % boundary nestGrid, antGrid, pherGrid
    for i=1:n+2
        nestGrid(i,1)=-1;
        nestGrid(i,n+2)=-1;
        roundFoodGrid(i,1)=-1;
        roundFoodGrid(i,n+2)=-1;
        pherGrid(i,1)=-1;
        pherGrid(i,n+2)=-1;
        antGrid(i,1,1:3)=[0 6 0];
        antGrid(i,n+2,1:3)=[0 6 0];
    end
    for j=2:n+1
        nestGrid(1,j)=-1;
        nestGrid(n+2,j)=-1;
        roundFoodGrid(1,j)=-1;
        roundFoodGrid(n+2,j)=-1;
        pherGrid(1,j)=-1;
        pherGrid(n+2,j)=-1;
        antGrid(1,j,1:3)=[0 6 0];
        antGrid(n+2,j,1:3)=[0 6 0];
    end
    t=1;
    figure
    while (sum(antGrid(:,22,3))<10)
        % pewarnaan
        for i=1:n+2
            for j=1:n+2
                if nestGrid(i,j)<=1 %bukan sarang
                    if roundFoodGrid(i,j)==2
                        % sumber makanan
                        warna(i,j,1:3) = [1 0 0.5];
                    else
                        if antGrid(i,j,1)>0
                            %ada semut
                            if antGrid(i,j,3)==1
                                warna(i,j,1:3)=[0 1 0]; %bawa makanan -> warna hijau
                            else
                                warna(i,j,1:3)=[(11-antGrid(i,j,1))/10 0 0]; %warna semut yang belum bawa makanan
                                %berdasarkan nomor urut semut
                            end
                        else %tidak ada semut
                            if pherGrid(i,j)>0
                                warna(i,j,1:3)=[(1-0.3*pherGrid(i,j)) 1 1];
                            else
                                warna(i,j,1:3) = 1;
                            end
                        end
                    end
                else
                    % sarang / nest
                    warna(i,j,1:3) = 0.5; 
                end
            end
        end
        image(warna(2:n+1,2:n+1,:));
        axis square
        tulis1 = sprintf('jumlah semut: %i', sum(sum(antGrid(:,:,1)>0)));
        tulis2 = sprintf('semut makan: %i', sum(sum(antGrid(:,:,3))));
        tulis3 = sprintf('waktu = %i s', t);
        xlabel(tulis1);
        ylabel(tulis2);
        title(tulis3);
        drawnow
       
        % SENSING
        for i=2:n+1
            for j=2:n+1
                if antGrid(i,j,1)>0 %terdapat semut
                    if antGrid(i,j,3)==1
                        %bawa makanan
                        lst = [nestGrid(i-1,j),nestGrid(i,j+1),nestGrid(i+1,j),nestGrid(i,j-1)];
                    else
                        %tidak bawa makanan
                        lst = [pherGrid(i-1,j),pherGrid(i,j+1),pherGrid(i+1,j),pherGrid(i,j-1)];
                    end
                   
                    % tidak akan menghadap ke sel asal
                    if antGrid(i,j,2)==1
                        % semut sedang menghadap ke utara, berarti berasal
                        % dari selatan
                        lst(3)=-2;
                    else
                        if antGrid(i,j,2)==2
                            % semut sedang menghadap ke timur, berarti berasal
                            % dari barat
                            lst(4)=-2;
                        else
                            if antGrid(i,j,2)==3
                                % semut sedang menghadap ke selatan, berarti berasal
                                % dari utara
                                lst(1)=-2;
                            else
                                if antGrid(i,j,2)==4
                                    % semut sedang menghadap ke barat, berarti berasal
                                    % dari timur
                                    lst(2)=-2;
                                end
                            end
                        end
                    end
                   
                    % semut tidak akan menghadap sel batas
                    if antGrid(i-1,j,2)==6 % utara sebagai sel batas
                        lst(1)=-2;
                    end
                    if antGrid(i+1,j,2)==6 % selatan sebagai sel batas
                        lst(3)=-2;
                    end
                    if antGrid(i,j+1,2)==6 % timur sebagai sel batas
                        lst(2)=-2;
                    end
                    if antGrid(i,j-1,2)==6 % barat sebagai sel batas
                        lst(4)=-2;
                    end
                   
                    if antGrid(i,j,3)==0
                        %semut yang belum membawa makanan tidak akan menghadap
                        %ke sarang
                        if nestGrid(i-1,j)==2 %utara adalah sarang
                            lst(1)=-2;
                        end
                        if nestGrid(i,j+1)==2 %timur adalah sarang
                            lst(2)=-2;
                        end
                        if nestGrid(i+1,j)==2 %selatan adalah sarang
                            lst(3)=-2;
                        end
                        if nestGrid(i,j-1)==2 %barat adalah sarang
                            lst(4)=-2;
                        end
                    else
                        %semut yang membawa makanan tidak akan menghadap ke
                        %sumber makanan
                        if roundFoodGrid(i-1,j)==2 %utara adalah sumber makanan
                            lst(1)=-2;
                        end
                        if roundFoodGrid(i,j+1)==2 %timur adalah sumber makanan
                            lst(2)=-2;
                        end
                        if roundFoodGrid(i+1,j)==2 %selatan adalah sumber makanan
                            lst(3)=-2;
                        end
                        if roundFoodGrid(i,j-1)==2 %barat adalah sumber makanan
                            lst(4)=-2;
                        end
                    end
                   
                    % semut tidak akan menghadap sel yang berisi semut lain
                    if antGrid(i-1,j,1)>0 % utara terdapat semut
                        lst(1)=-2;
                    end
                    if antGrid(i+1,j,1)>0 % selatan terdapat semut
                        lst(3)=-2;
                    end
                    if antGrid(i,j+1,1)>0 % timur terdapat semut
                        lst(2)=-2;
                    end
                    if antGrid(i,j-1,1)>0 % barat terdapat semut
                        lst(4)=-2;
                    end
                   
                    % semut menghadap ke sel yang berisi pherormone paling
                    % banyak
                    mx = max(lst);
                    if mx<0
                        antGrid(i,j,2)=5; % semut tetap di sel tsb
                    else
                        posList = find(lst==mx); % posisi nilai maksimum
                        lng = length(posList);
                        rndPos = randi([1,lng]);
                        antGrid(i,j,2) = posList(rndPos); %1 = utara, 2 = timur, 3 = selatan, 4 = barat
                    end
                end
            end
        end
       
        % WALKING
        newAntGrid = antGrid;
        newPherGrid = pherGrid;
        for i=2:n+1
            for j=2:n+1
                if antGrid(i,j,1)==0 % tidak ada semut
                    if i~=makanan(1,1) && j~=makanan(1,2)
                        % pheromone di sumber makanan tidak akan
                        % terevaporasi
                        if pherGrid(i,j)>0
                            % pheromone berkurang
                            newPherGrid(i,j) = newPherGrid(i,j) - EVAPORATE;
                            if newPherGrid(i,j) < 0
                                newPherGrid(i,j)=0;
                                %pheromone tidak boleh negatif
                            end
                        end
                    end
                else
                    % ada semut
                    if i==2 || i==n+1 || j==2 ||j==n+1
                        arah_semut_lain = [newAntGrid(i-1,j-1,2) newAntGrid(i-1,j,2) newAntGrid(i-1,j+1,2) newAntGrid(i,j+1,2) newAntGrid(i+1,j+1,2) newAntGrid(i+1,j,2) newAntGrid(i+1,j-1,2) newAntGrid(i,j-1,2) 6 6 6 6];
                    else
                        arah_semut_lain = [newAntGrid(i-1,j-1,2) newAntGrid(i-1,j,2) newAntGrid(i-1,j+1,2) newAntGrid(i,j+1,2) newAntGrid(i+1,j+1,2) newAntGrid(i+1,j,2) newAntGrid(i+1,j-1,2) newAntGrid(i,j-1,2) newAntGrid(i-2,j,2) newAntGrid(i,j+2,2) newAntGrid(i+2,j,2) newAntGrid(i,j+2,2)];
                    end
                    % posisi semut lain terhadap site: barat laut(1), utara(2), timur laut(3), timur(4),
                    % tenggara(5), selatan(6), barat daya(7), barat (8),
                    % utara utara (9), timur timur (10), selatan selatan
                    %(11), barat barat (12)
                    if arah_semut_lain(2*newAntGrid(i,j,2))==0 % di arah yg bersesuaian tidak ada semut
                        if newAntGrid(i,j,2)~=5
                            if (arah_semut_lain(2*newAntGrid(i,j,2)-1)==mod(newAntGrid(i,j,2)+1,4) || arah_semut_lain(2*newAntGrid(i,j,2)-1)==mod(newAntGrid(i,j,2)+1,4)+4) || (arah_semut_lain(2*newAntGrid(i,j,2)+1)==mod(newAntGrid(i,j,2)+3,4) || arah_semut_lain(2*newAntGrid(i,j,2)+1)==mod(newAntGrid(i,j,2)+3,4)+4) || (arah_semut_lain(newAntGrid(i,j,2)+8)==mod(newAntGrid(i,j,2)+2,4) || arah_semut_lain(newAntGrid(i,j,2)+8)==mod(newAntGrid(i,j,2)+2,4)+4)
                                % mungkin terjadi tabrakan
                                if rand<0.5
                                    deposite = THRESHOLD*roundFoodGrid(i,j); % deposite berbanding lurus dengan jarak ke sumber makanan
                                    if antGrid(i,j,3)==1
                                        % semut membawa makanan
                                        newPherGrid(i,j)= newPherGrid(i,j) + deposite;
                                    else
                                        % semut tidak membawa makanan
                                        if newPherGrid(i,j)>THRESHOLD
                                            newPherGrid(i,j)= newPherGrid(i,j) + deposite;
                                        end
                                    end
                                    % semut bergerak
                                    newAntGrid(i,j,1:3)=0;
                                    if antGrid(i,j,2)==1 % utara
                                        newAntGrid(i-1,j,1:3)= antGrid(i,j,1:3);
                                    else
                                        if antGrid(i,j,2)==2 % timur
                                            newAntGrid(i,j+1,1:3)= antGrid(i,j,1:3);
                                        else
                                            if antGrid(i,j,2)==3 % selatan
                                                newAntGrid(i+1,j,1:3)= antGrid(i,j,1:3);
                                            else
                                                if antGrid(i,j,2)==4 % barat
                                                    newAntGrid(i,j-1,1:3)= antGrid(i,j,1:3);
                                                end
                                            end
                                        end
                                    end
                                else
                                    % semut diam
                                    newAntGrid(i,j,2)=5;
                                end
                            else
                                deposite = THRESHOLD*roundFoodGrid(i,j); % deposite berbanding lurus dengan jarak ke sumber makanan
                                if antGrid(i,j,3)==1
                                    % semut membawa makanan
                                    newPherGrid(i,j)= newPherGrid(i,j) + deposite;
                                else
                                    % semut tidak membawa makanan
                                    if newPherGrid(i,j)>THRESHOLD
                                        newPherGrid(i,j)= newPherGrid(i,j) + deposite;
                                    end
                                end
                                % semut bergerak
                                newAntGrid(i,j,1:3)=0;
                                if antGrid(i,j,2)==1 % utara
                                    newAntGrid(i-1,j,1:3)= antGrid(i,j,1:3);
                                else
                                    if antGrid(i,j,2)==2 % timur
                                        newAntGrid(i,j+1,1:3)= antGrid(i,j,1:3);
                                    else
                                        if antGrid(i,j,2)==3 % selatan
                                            newAntGrid(i+1,j,1:3)= antGrid(i,j,1:3);
                                        else
                                            if antGrid(i,j,2)==4 % barat
                                                newAntGrid(i,j-1,1:3)= antGrid(i,j,1:3);
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    else
                        % ada semut di arah yg bersesuaian
                        newAntGrid(i,j,2)=5; % stay
                    end
                end
            end
        end
        antGrid = newAntGrid;
        pherGrid = newPherGrid;
       
        % DIFUSI PHEROMONE
        for i=2:n+1
            for j=2:n+1
                if i~=makanan(1,1) && j~=makanan(1,2)
                    % pheromone di sumber makanan tidak akan terdifusi
                    pher_tetangga = [pherGrid(i-1,j-1) pherGrid(i-1,j) pherGrid(i-1,j+1) pherGrid(i,j+1) pherGrid(i+1,j+1) pherGrid(i+1,j) pherGrid(i+1,j-1) pherGrid(i,j-1)];
                    pherGrid(i,j) = pherGrid(i,j)*(1-8*DIFUSI) + DIFUSI*sum(pher_tetangga);
                    if pherGrid(i,j)<0
                        pherGrid(i,j)=0;
                    end
                end
            end
        end
       
        %SEMUT MENDAPATKAN MAKANAN
        if antGrid(makanan(1,1),makanan(1,2),1)>0
            % ada semut di sumber makanan / semut mendapatkan makanan
            antGrid(makanan(1,1),makanan(1,2),3)=1;
            % waktu yang dibutuhkan semut tsb untuk mendapatkan makanan
            % adalah:
            waktu(k,antGrid(makanan(1,1),makanan(1,2),1))=t-t_keluar(antGrid(makanan(1,1),makanan(1,2),1));
        end
       
       %semut keluar dari sarang
       for antNum=1:10
           if t==10*(antNum-1)+1
               antGrid(sarang(1,1),sarang(1,2),1:3)=[antNum randi(4) 0];
               t_keluar(antNum)=t;
           end
       end
       
        %semut keluar dari sarang
        %if t==1
         %   p1=rand;
          %  if p1<0.5
           %     antGrid(2,3,1:3) = [1, randi(4), 0];
            %else
             %   antGrid(3,2,1:3) = [1, randi(4), 0];
            %end
        %end
        %antNum=2;
        %keluar=0;
        %while antNum<=10 && keluar==0
         %   if antGrid(2,2,1)==antNum-1 && antGrid(2,2,3)==1 && antGrid(2,2,4)==1
          %      p1=rand;
           %     keluar=1;
            %    if p1<0.5
             %       antGrid(2,3,1:3) = [antNum, randi(4), 0];
              %  else
               %     antGrid(3,2,1:3) = [antNum, randi(4), 0];
                %end
            %end
            %antNum=antNum+1;
        %end
       
        %semut kembali ke sarang
        no_semut = antGrid(sarang(1,1),sarang(1,2),1);
        if no_semut>0 && antGrid(sarang(1,1),sarang(1,2),3)==1
            % semut kembali ke sarang dan membawa makanan
            % informasi semut makan disimpan ke kolom 22
            antGrid(no_semut,22,1:3) = [0 0 1];
            antGrid(sarang(1,1),sarang(1,2),1:3)=0;
        end
        t=t+1;
    end
    % pewarnaan
    for i=1:n+2
        for j=1:n+2
            if nestGrid(i,j)<=1 %bukan sarang
                if roundFoodGrid(i,j)==2
                    % sumber makanan
                    warna(i,j,1:3) = [1 0 0.5];
                else
                    if antGrid(i,j,1)>0
                        %ada semut
                        if antGrid(i,j,3)==1
                            warna(i,j,1:3)=[0 1 0]; %bawa makanan -> warna hijau
                        else
                            warna(i,j,1:3)=[(11-antGrid(i,j,1))/10 0 0]; %warna semut yang belum bawa makanan
                            %berdasarkan nomor urut semut
                        end
                    else %tidak ada semut
                        if pherGrid(i,j)>0
                            warna(i,j,1:3)=[(1-0.3*pherGrid(i,j)) 1 1];
                        else
                            warna(i,j,1:3) = 1;
                        end
                    end
                end
            else
                % sarang / nest
                warna(i,j,1:3) = 0.5;
            end
        end
    end
    image(warna(2:n+1,2:n+1,:));
    axis square
    tulis1 = sprintf('jumlah semut: %i', sum(sum(antGrid(:,:,1)>0)));
    tulis2 = sprintf('semut makan: %i', sum(sum(antGrid(:,:,3))));
    tulis3 = sprintf('waktu = %i s', t);
    xlabel(tulis1);
    ylabel(tulis2);
    title(tulis3);
    drawnow
end

%menghitung rata-rata waktu setiap semut mendapatkan makanan
%dan memplotnya ke dalam grafik
for antNum = 1:10
    rata_waktu(antNum) = mean(waktu(:,antNum));
end
figure
antNum = 1:10;
hold on
plot(antNum,rata_waktu,'ok','MarkerSize',7,'MarkerFaceColor','k');
xlabel('nomor urut semut');
ylabel('rata-rata waktu untuk mendapatkan makanan');
tulis = sprintf('Jarak dari sarang ke sumber makanan: %f', jarak);
f = polyfit(antNum,rata_waktu,1)
y = polyval(f,antNum);
plot(antNum,y, 'r');
hold off
title(tulis);
