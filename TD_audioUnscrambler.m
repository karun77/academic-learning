
[x2,fs1] = audioread('TD_scrambledAudio.wav');

shuffle = @(v)v(randperm(numel(v)));

fileID = fopen('randomSeedForTDscrambling.txt','r');
s1 = fscanf(fileID,'%d');
fclose(fileID);

c = 1;

rng(s1)

x3 = zeros(40000,1);

for i=shuffle(1:numel(x2))
    x3(i) = x2(c);
    c = c+1;
end

audiowrite('TD_unscrambledAudio.wav',x3,fs1);
