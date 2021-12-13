
%to use the functions Cipher and halfprecision use the code from here:
%https://in.mathworks.com/matlabcentral/fileexchange/23173-ieee-754r-half-precision-floating-point-converter
%https://in.mathworks.com/matlabcentral/fileexchange/73412-advanced-encryption-standard-aes-128-192-256

%for this example i encrypt all the sound data, using this key:
%key = '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f';
%the same will be used to decrypt as well, since we're using symmetric
%encryption

[y,fs] = audioread('Pink-Panther_clipped.wav');

y = [y;0];

c = 1;
h = string(zeros(9647,1));
key = '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f';

h(1) = '';

for i = 1:numel(y)
    if c > 8
        c = 1;
        h(1 + (i-c)/8) = '';
    end

    n = 1 + (i-c)/8;
    y(i) = halfprecision(y(i));
    sInHex = sprintf('%04x',y(i));
    gdstr = h(n);

    h(n) = strcat(gdstr,sInHex);

    c = c+1;
end

henc = string(zeros(9647,1));

for i = 1:numel(h)
    %the Cipher function requires the hex string to be fed in as a char array
    henc(i) = Cipher(key,char(h(i)));
end

fileID = fopen('AESencryptedArray.txt','w');
fprintf(fileID,'%s\r\n',henc);
fclose(fileID);