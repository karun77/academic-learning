
[x1,fs] = audioread('testVoice1.wav');

n = length(x1);
x1f = fftshift(fft(x1));

fshift = (-n/2:n/2-1)*(fs/n);

subplot(2,1,1);
plot(fshift,abs(x1f));
xlabel('f'),ylabel('M(f)'),title('original message signal spectrum');

% i will choose the maximum baseband frequency to be 2000 Hz
% now to flip

x1fFN = x1f(10001:20000);
x1fFP = x1f(20002:30001);

x1fFN = flip(x1fFN);
x1fFP = flip(x1fFP);

x1fInv = zeros(40000,1);

x1fInv(1:10000) = x1f(1:10000);
x1fInv(10001:20000) = x1fFN;
x1fInv(20001) = x1f(20001);
x1fInv(20002:30001) = x1fFP;
x1fInv(30002:40000) = x1f(30002:40000);

subplot(2,1,2);
plot(fshift,abs(x1fInv));
xlabel('f'),ylabel('Ms(f)'),title('scrambled message signal spectrum');

x1Inv = ifft(ifftshift(x1fInv));

%writetable(table(x1Inv),'writevariablenames',0)

audiowrite('basband_inversion.wav',x1Inv,fs);
