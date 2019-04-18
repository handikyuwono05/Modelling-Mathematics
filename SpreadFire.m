clc
clear all
close all
n = 17;
for p=1:9
    for k=1:10
        %% INISIALISASI
        forest(2:n+1,2:n+1)=ones(17);
        %forest yang di tengah
        %terbakar
        forest(10,10)=2;
        %% KONDISI BATAS
        %periodic
        for i=2:(n+1)
            forest(i,1) = forest(i,n+1);
            forest(i,n+2) = forest(i,2);
        end
        for j=1:(n+2)
            forest(1,j)=forest(n+1,j);
            forest(n+2,j)=forest(2,j);
        end
       
        %% pewarnaan
        for i=2:n+1
            for j=2:n+1
                if forest(i,j)==0
                    b(i,j,1:3)=1;
                else
                    if forest(i,j)==1;
                        b(i,j,1)=0;
                        b(i,j,2)=1;
                        b(i,j,3)=0;
                    else
                        b(i,j,1)=1;
                        b(i,j,2:3)=0;
                    end
                end
            end
        end
        if k==10
            figure
            image(b(2:n+1,2:n+1,1:3))
            axis square
            drawnow
        end
        %% ITERASI
        burnprob=p*0.1;
        setimbang=0;
        while (setimbang==0)
            c=forest;
            for i=2:(n+1)
                for j=2:(n+1)
                    if forest(i,j)==1
                        if forest(i-1,j)==2 || forest(i,j+1)==2 || forest(i+1,j)==2 || forest(i,j-1)==2
                            p1 = rand;
                            if p1 < burnprob
                                c(i,j)=2;
                            end
                        end
                    else
                        if forest(i,j)==2
                            c(i,j)=0;
                        end
                    end
                end
            end
            forest=c;

            % KONDISI BATAS
            %periodic
            for i=2:(n+1)
                forest(i,1) = forest(i,n+1);
                forest(i,n+2) = forest(i,2);
            end
            for j=1:(n+2)
                forest(1,j)=forest(n+1,j);
                forest(n+2,j)=forest(2,j);
            end
           
            %memeriksa kondisi setimbang
            if sum(sum(forest==2))==0;
                %tidak ada yang terbakar
                setimbang=1;
            end

            % pewarnaan
            for i=2:n+1
                for j=2:n+1
                    if forest(i,j)==0
                        b(i,j,1:3)=1;
                    else
                        if forest(i,j)==1;
                            b(i,j,1)=0;
                            b(i,j,2)=1;
                            b(i,j,3)=0;
                        else
                            b(i,j,1)=1;
                            b(i,j,2:3)=0;
                        end
                    end
                end
            end
            if k==10
                image(b(2:n+1,2:n+1,1:3))
                axis square
                drawnow
            end
        end
        pohon_terbakar = sum(sum(forest(2:n+1,2:n+1)==0));
        persen_pohon_terbakar(p,k) = pohon_terbakar*100/(n*n);
    end
    tulis1= sprintf('Burn probability = %i persen, percobaan ke-%i', p*10, k);
    title(tulis1)
    tulis2 = sprintf('persentase pohon terbakar = %f persen', persen_pohon_terbakar(p,k));
    xlabel (tulis2)
    rata2_terbakar(p) = mean(persen_pohon_terbakar(p,:));
end
prob=0.1:0.1:0.9;
figure
hold on
plot(prob,rata2_terbakar, 'o','MarkerSize',5,'MarkerFaceColor','k');
xlabel('burn probability');
ylabel('rata-rata persentase pohon terbakar');
f = polyfit(prob,rata2_terbakar,3)
x=0.1:0.0001:0.9;
y = polyval(f,x);
plot(x,y);
title('KEBAKARAN HUTAN');
hold off
