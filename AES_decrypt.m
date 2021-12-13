

%to use the functions InvCipher and halfprecision use the code from here:
%https://in.mathworks.com/matlabcentral/fileexchange/23173-ieee-754r-half-precision-floating-point-converter
%https://in.mathworks.com/matlabcentral/fileexchange/73412-advanced-encryption-standard-aes-128-192-256
% 
% fileID1 = fopen('AESencryptedArray.txt','r');
% henc1 = textscan(fileID1,'%s\r\n');
% fclose(fileID1);

henc1 = importdata('AESencryptedArray.txt');

key = '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f';
hdec = string(zeros(9647,1));

for i = 1:numel(henc1)
    %the Cipher function on the hex string fed as a char array
    hdec(i) = InvCipher(key,char(henc1(i)));
    if strlength(hdec(i))==16
        hdec(i) = strcat('0000000000000000',hdec(i));
    end
end

y1 = double(zeros(77176,1));

for i = 1:numel(hdec)
    str = char(hdec(i));
    for c = 1:8
        y1((4*(i-1)) + c) = hex2dec(str((1+(c-1)*4):(1+((c-1)*4)+3)));
    end
end

y1(end) = []; %removing the extra padding added for this aes encryption algorithm

for i = 1:numel(y1)
    y1(i) = halfprecision(uint16(y1(i)),'double');
end
