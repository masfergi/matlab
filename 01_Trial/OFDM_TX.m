clear 
clc
close all
% Deklarasi %%

%Bit = 2560 %Jumlah Bit
Bit = 2048; %Jumlah Bit, Menyimpan Infromasi Banyaknya Bit
M   = 4 ;    %Order Modulasi
N   = 128;   %Jumlah SubCarrier
I   = 4;     %Interval Pilot
E   = 2;     %Energi Pilot
SNR = 0: 1: 40;
snr_vector = 0: 1: 40;

% ---- SISI PENGIRIM ---- %
% Pembangkitan Data Input %%
TS_QAM = Bit/M; % Menyimpan Infromasi Banyaknya Simbol QAM
GenBit = randi([0 (M-1)],TS_QAM,1); % Menyimpan data/simbol-simbol QAM

% QAM %
SimbolQAM = qammod(GenBit,M); % odulasi QAM, hasilnya bilangan Kompleks

%PLOT MODULASI QAM%

scatterplot(SimbolQAM)
text(real(SimbolQAM)+0.1, imag(SimbolQAM), dec2bin(GenBit));
axis([-2 2 -2 2]);
title('Konstelasi QAM')

figure(2)
stem(GenBit)
title('Data yang dibangkitkan')

% --- Proses "Pilot Insertion" MULAI --- %
% pilot = randi([2 2],1,(length(SimbolQAM)/I));
[acb,ack] = size(SimbolQAM); % Simpan Informasi Matriks SimbolQAM
% [bcb,bck] = size(pilot);
% z_a = 1;
% z_b = 1; 

%SimbolQAM2 = SimbolQAM'
% pilot2 = pilot';
data_pilot = SimbolQAM; % Copy Paste

% --- COMB BISA --- %
% Lokasi_Pilot = 1:I:acb;
% data_pilot(Lokasi_Pilot,:) = E * data_pilot(Lokasi_Pilot,:);


% --- BLOCK --- %
jumlah_simbol_QAM = acb; % Menyalin Infromasi "banyak baris"
jumlah_simbol_OFDM = jumlah_simbol_QAM / N;
loc = 1:I:jumlah_simbol_OFDM; % Informasi Posisi Pilot
% count = 0;
loop = 1;
k = 1;

for i = 1 : jumlah_simbol_OFDM
%     if loc(k) == i
    if i == loc(k)
        for j = 1 : N
            data_pilot(loop) = E * data_pilot(loop);
            loop = loop + 1;
        end
        k = k + 1;
        if k > length(loc)
            k = 1;
        end
    else
        for j = 1 : N
            loop = loop + 1;
        end
    end
end


% for i=0:acb+bck
%   if mod(i,acb/bck) == 0 
%       data_pilot(Lokasi_Pilot,:) = E * data_pilot(Lokasi_Pilot,:);
%     if z_b ~= bck
%       data_pilot(i,:) = pilot(z_b,:)
%       z_b = z_b + 1;
%     end
%   else
%     data_pilot(i,:) = SimbolQAM2(z_a,:)
%     z_a = z_a + 1;
%   end
% end
% ukuran variable data_pilot = pilot + SimbolQAM2 = 64 + 256 = 319

% --- OFDM --- %
% QAM_PER_SC = acb/N;
NSymbol = TS_QAM / N;     % Jumlah simbol OFDM = Jumlah Simbol QAM / Subc

pardata = reshape(data_pilot',N,NSymbol);
dataIFFT= ifft(pardata,N);

% plot(1:length(dataIFFT),dataIFFT)
%Paralel to serial%
xt = reshape(dataIFFT,1,[]);    % SINYAL OFDM
%Plot Sinyal OFDM
figure(3)
plot(1:length(xt),xt)
title('Sinyal OFDM sebelum kanal')



% --- Penambahan CP --- %


% ---- KANAL ---- %
h = 1/sqrt(2)*[randn(1,length(xt)) + j*randn(1,length(xt))]; 

% ---- SINYAL TERIMA --- %
rx = h.*xt; % Ini nanti tambahkan PILOT jangan cuma XT murni

figure(4)
plot(1:length(rx),rx)
title('Sinyal OFDM sesudah kanal')

count=0 ;
% --- SISI PENERIMA --- %
for snr=snr_vector
    SNR_x = snr + 10*log10(log2(M));
    count=count+1 ;
    
    d_parallel_fft=fft(rx);
    dt_p = data_pilot'; %1 x 512
    
    ambil_pilot = jumlah_simbol_OFDM/4;
    
    TxP = dt_p(:,1:128); %PILOT DIKIRIM
    RxP = d_parallel_fft(:,1:128); %PILOT DITERIMA
    
    for r=1:NSymbol
        H_MMSE(:,r) = MMSE(RxP(:,r),TxP(:,r),N,I,h,SNR_x);
    end
    
    HData_MMSE_parallel1=H_MMSE.';
    
end
