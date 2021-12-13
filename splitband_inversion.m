
function Out = splitband_inversion(audioFile,fsp)

    [x1,fs] = audioread(audioFile);
    
    n = length(x1);
    x1f = fftshift(fft(x1));
    
    fshift = (-n/2:n/2-1)*(fs/n);
    
    figure;
    subplot(2,1,1);
    plot(fshift,abs(x1f));
    xlabel('f'),ylabel('M(f)'),title('original message signal');
    
    % i choose maximum baseband freq = 2000 Hz and splitband freq = 800 Hz
    fb = 2000;

    %splitband frequency
    n2 = (n/2 + 1) - (fsp/(fs/n)); n1 = n2-1; n3 = (n/2 + 1) + (fsp/(fs/n)); n4 = n3+1;
    
    x1fFN = x1f((fb/(fs/n) + 1):n1);
    x2fFN = x1f(n2:n/2);
    x2fFP = x1f((n/2 + 2):n3);
    x1fFP = x1f(n4:(n/2 + 1 + fb/(fs/n)));
    
    x1fFN = flip(x1fFN);
    x2fFN = flip(x2fFN);
    x2fFP = flip(x2fFP);
    x1fFP = flip(x1fFP);
    
    
    x1fInv = zeros(n,1);
    
    x1fInv(1:fb/(fs/n)) = x1f(1:fb/(fs/n));
    x1fInv(fb/(fs/n) + 1:n1) = x1fFN;
    x1fInv(n2:n/2) = x2fFN;
    x1fInv(n/2 + 1) = x1f(n/2 + 1);
    x1fInv((n/2 + 2):n3) = x2fFP;
    x1fInv(n4:(n/2 + 1 + fb/(fs/n))) = x1fFP;
    x1fInv((n/2 + 2 + fb/(fs/n)):n) = x1f((n/2 + 2 + fb/(fs/n)):n);
    
    subplot(2,1,2);
    plot(fshift,abs(x1fInv));
    xlabel('f'),ylabel('Ms(f)'),title('scrambled message signal');
    
    x1Inv = ifft(ifftshift(x1fInv));
    
    %writetable(table(x1Inv),'writevariablenames',0)
    
    audiowrite('splitband_inversion.wav',x1Inv,fs);
end
