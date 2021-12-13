
fsp_array = [800 900 1000 1100];

shuffle = @(v)v(randperm(numel(v)));

fsp_array1 = zeros(4,1);
c = 1;
for i=shuffle(1:numel(fsp_array1))
    fsp_array1(c) = fsp_array(i);
    c = c+1;
end

[x,fs3] = audioread('testVoice1.wav');

% x has 740736 elements, so i divide into 4 sections 185184 elements each
k = 8000;
y1 = x(1:k); y2 = x((k+1):2*k); y3 = x((2*k+1):3*k); y4 = x((3*k+1):4*k);

audiowrite('splitHopping1.wav',y1,fs3);
audiowrite('splitHopping2.wav',y2,fs3);
audiowrite('splitHopping3.wav',y3,fs3);
audiowrite('splitHopping4.wav',y4,fs3);

splitband_inversion('splitHopping1.wav',fsp_array1(1))
y1e = audioread('splitband_inversion.wav');
audiowrite('splitHopping1e.wav',y1e,fs3);

splitband_inversion('splitHopping2.wav',fsp_array1(2))
y2e = audioread('splitband_inversion.wav');
audiowrite('splitHopping2e.wav',y2e,fs3);

splitband_inversion('splitHopping3.wav',fsp_array1(3))
y3e = audioread('splitband_inversion.wav');
audiowrite('splitHopping3e.wav',y3e,fs3);

splitband_inversion('splitHopping4.wav',fsp_array1(4))
y4e = audioread('splitband_inversion.wav');
audiowrite('splitHopping4e.wav',y4e,fs3);

splitbandInv_decryption('splitHopping1e.wav',fsp_array1(1));
y5 = audioread('splitbandInv_decryption.wav');

splitbandInv_decryption('splitHopping2e.wav',fsp_array1(2));
y6 = audioread('splitbandInv_decryption.wav');

splitbandInv_decryption('splitHopping3e.wav',fsp_array1(3));
y7 = audioread('splitbandInv_decryption.wav');

splitbandInv_decryption('splitHopping4e.wav',fsp_array1(4));
y8 = audioread('splitbandInv_decryption.wav');

%final decrypted array
y9 = [y5;y6;y7;y8];

audiowrite('splitbandWithHoppingDC.wav',y9,fs3);







