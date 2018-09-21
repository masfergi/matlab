clear
clc
close all
% Deklarasi %%

%Bit = 2560 %Jumlah Bit
Bit = 2048  %Jumlah Bit
M   = 4     %Order Modulasi
N   = 128   %Jumlah SubCarrier
I   = 4     %Interval Pilot
E   = 2     %Energi Pilot
SNR = 0: 1: 40;

% ---- SISI PENGIRIM ---- %
% Pembangkitan Data Input %%
TS_QAM = Bit/M;
GenBit = randi([0 (M-1)],TS_QAM,1);

% QAM %
SimbolQAM = qammod(GenBit,M); % Kompleks

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
[acb,ack] = size(SimbolQAM);
% [bcb,bck] = size(pilot);
z_a = 1;
z_b = 1; 

%SimbolQAM2 = SimbolQAM'
% pilot2 = pilot';
data_pilot = SimbolQAM;

Lokasi_Pilot = 1:I:acb;
data_pilot(Lokasi_Pilot,:) = E * data_pilot(Lokasi_Pilot,:);

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
rx = h.*xt;

figure(4)
plot(1:length(rx),rx)
title('Sinyal OFDM sesudah kanal')
