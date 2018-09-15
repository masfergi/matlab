clear
clc

a = randi([0 3],4,16);
b = randi([2 2],4,4);

M = 4 %ordo modulasi QAM
I = 4 %interval pilot insertion

% Pembangkitan Data
a = qammod(a,M)

[acb,ack] = size(a);
[bcb,bck] = size(b);

z_a = 1;
z_b = 1;

for i=1:ack+bck
  if mod(i,ack/bck) == 0 
    if z_b != bck
      c(:,i) = b(:,z_b)
      z_b++;
    end
  else
    c(:,i) = a(:,z_a) 
    z_a++;
  end
end