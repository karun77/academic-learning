
function Out = splitbandInv_decryption(audioFile,fsp)

[x2,fs] = audioread(audioFile);

n = length(x2);
x2f = fftshift(fft(x2));

% fshift1 = (-n1/2:n1/2-1)*(fs1/n1);
% 
% figure;
% subplot(2,1,1);
% plot(fshift1,abs(x2f));

fb = 2000;
% reversing the frequency inversion
n2 = (n/2 + 1) - fsp/(fs/n); n1 = n2-1; n3 = (n/2 + 1) + fsp/(fs/n); n4 = n3+1;

x3fFN = x2f(fb/(fs/n) + 1:n1);
x4fFN = x2f(n2:n/2);
x4fFP = x2f(n/2 + 2:n3);
x3fFP = x2f(n4:(n/2 + 1 + fb/(fs/n)));

x3fFN = flip(x3fFN);
x4fFN = flip(x4fFN);
x4fFP = flip(x4fFP);
x3fFP = flip(x3fFP);


x2fInv = zeros(n,1);

x2fInv(1:fb/(fs/n)) = x2f(1:fb/(fs/n));
x2fInv(fb/(fs/n) + 1:n1) = x3fFN;
x2fInv(n2:n/2) = x4fFN;
x2fInv(n/2 + 1) = x2f(n/2 + 1);
x2fInv(n/2 + 2:n3) = x4fFP;
x2fInv(n4:(n/2 + 1 + fb/(fs/n))) = x3fFP;
x2fInv((n/2 + 2 + fb/(fs/n)):n) = x2f((n/2 + 2 + fb/(fs/n)):n);

% subplot(2,1,2);
% plot(fshift1,abs(x2fInv));

x2Inv = ifft(ifftshift(x2fInv));

audiowrite('splitbandInv_decryption.wav',x2Inv,fs);

end
