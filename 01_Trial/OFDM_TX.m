clear
clc
close all
% Deklarasi %%

%Bit = 2560 %Jumlah Bit
Bit = 1024  %Jumlah Bit
M   = 4     %Order Modulasi
N   = 128   %Jumlah SubCarrier
I   = 4     %Interval Pilot

% Pembangkitan Data Input %%
TS_QAM = Bit/M
GenBit = randi([0 (M-1)],TS_QAM,1);

% QAM %
SimbolQAM = qammod(GenBit,M);

%PLOT MODULASI QAM%
scatterplot(SimbolQAM)
text(real(SimbolQAM)+0.1, imag(SimbolQAM), dec2bin(GenBit));
axis([-2 2 -2 2]);

%Proses "Pilot Insertion" MULAI
pilot = randi([2 2],1,(length(SimbolQAM)/I));

[acb,ack] = size(SimbolQAM);
[bcb,bck] = size(pilot);

z_a = 1;
z_b = 1; 

for i=1:acb+bck
  if mod(i,acb/bck) == 0 
    if z_b ~= bck
      data_pilot(:,i) = pilot(:,z_b)
      z_b = z_b + 1;
    end
  else
    data_pilot(:,i) = SimbolQAM(:,z_a)
    z_a = z_a + 1;
  end
end

%Proses "Pilot Insertion" SELESAI
% OFDM %%
NSymbol = TS_QAM+bck/N;
pardata = reshape(data_pilot',N,NSymbol);
dataIFFT= ifft(pardata,N);

%PLOT IFFT%
% plot(1:length(dataIFFT),dataIFFT)
%Paralel to serial%
xt = reshape(dataIFFT,1,[]);
%Plot Sinyal OFDM
figure(2)
plot(1:length(xt),xt)

