clc;clear;
%DEKLARASI VARIABLE
nbit    = 16; %Jumlah bit
M       = 4;  %Ordo Modulasi

%PEMBANGKITAN BIT
msg = randi([0 1],nbit,1);

%MODULASI
msg_reshape = reshape(msg,log2(M),length(msg)/log2(M))';

for(j=1:1:nbit/log2(M))
   for(i=1:1:log2(M))
       a(j,i)=num2str(msg_reshape(j,i)); %mengubah binary ke string
   end
end
dec_msg=bin2dec(a)'; %mengubah string binary ke nilai desimal
sQAM = qammod(dec_msg,M);

R_sQAM = real(sQAM);
I_sQAM = imag(sQAM);