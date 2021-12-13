
[x2,fs1] = audioread('basband_inversion.wav');

n1 = length(x2);
x2f = fftshift(fft(x2));

fshift1 = (-n1/2:n1/2-1)*(fs1/n1);

figure;
subplot(2,1,1);
plot(fshift1,abs(x2f));
xlabel('f'),ylabel('Ms(f)'),title('scrambled message signal spectrum');

% reversing the frequency inversion

x2fFN = x2f(10001:20000);
x2fFP = x2f(20002:30001);

x2fFN = flip(x2fFN);
x2fFP = flip(x2fFP);

x2fInv = zeros(40000,1);

x2fInv(1:10000) = x2f(1:10000);
x2fInv(10001:20000) = x2fFN;
x2fInv(20001) = x2f(20001);
x2fInv(20002:30001) = x2fFP;
x2fInv(30002:40000) = x2f(30002:40000);

subplot(2,1,2);
plot(fshift1,abs(x2fInv));
xlabel('f'),ylabel('M(f)'),title('original message signal spectrum');

x2Inv = ifft(ifftshift(x2fInv));

audiowrite('basbandInv_decryption.wav',x2Inv,fs1);
