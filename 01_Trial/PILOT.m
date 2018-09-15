clear
clc
% Deklarasi Variable
M = 4 %ordo modulasi QAM
%I = 4 %interval pilot insertion

% Pembangkitan Data
a = randi([0 3],4,16);
b = randi([2 2],4,4);

d_qam = qammod(a,M)

% Lokasi
[acb,ack] = size(a);
[bcb,bck] = size(b);

z_a = 1;
z_b = 1; 

% Loop Pilot Insertion

for i=1:ack+bck
  if mod(i,ack/bck) == 0 
    if z_b != bck
      c(:,i) = b(:,z_b)
      z_b++;
    end
  else
    c(:,i) = d_qam(:,z_a) 
    z_a++;
  end
end

% Plot 
figure(1)
plot(d_qam,"b*",-2,-2,2,2)

figure(2)