clc
clear all

half_life = 22;
time = 0;
volume = 3000;
dosage = 100*1000;
absorption_fraction = 0.12;
elimcons = log(2)/half_life;
lambung = 0;
entering = absorption_fraction*dosage;
i = 0;
penurunanrate = 1/48000;
darah = 0;
intodruginsystem = 0;
druginsystem = 0;

for time = 0:168
    %masukin obat ke lambung tiap 8 jam
    if (mod(time,8) == 0)
        lambung = lambung + entering;
    end
    %memproses obat selama time mod 8 < 4
    if (mod(i,8) < 5)
        %penyerapan dari lambung ke darah dengan laju penyerapan
        %sebanding dengan jumlah obat di lambung
        ratelambungdarah = penurunanrate * lambung;
        darah = darah + (ratelambungdarah * lambung);
        lambung = lambung - darah;
        %dari darah ke sebelum sistem. di darah obat berkurang juga karena
        %meluruh
        intodruginsystem = intodruginsystem + darah - (elimcons * druginsystem);
        %obat di darah juga berkurang  selama prosesnya
        darah = darah - intodruginsystem;
        %obat di druginsystem bertambah dari intodruginsystem
        druginsystem = druginsystem + intodruginsystem;
        %semua obat di intodruginsystem sudah habis
        intodruginsystem = 0;
        concentration = druginsystem/volume;
    else
        druginsystem = druginsystem - (elimcons*druginsystem);
        concentration = druginsystem/volume;
    end

    y(time+1) = concentration ;
    x(time+1) = time ;
    time = time + 1;
    i = i + 1;
    plot (x,y);
    pause(0.1)
    title('Grafik Kerja Dilantin Dalam Tubuh')
    xlabel('Days')
    ylabel('Concenctration')
end
