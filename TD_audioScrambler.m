
[x,fs] = audioread('testVoice1.wav');


shuffle = @(v)v(randperm(numel(v)));

s = getfield(rng('shuffle'),'Seed');
c = 1;

rng(s)

x1 = zeros(40000,1);

for i=shuffle(1:numel(x))
    x1(c) = x(i);
    c = c+1;
end

fileID = fopen('randomSeedForTDscrambling.txt','w');
fprintf(fileID,'%d',s);
fclose(fileID);

audiowrite('TD_scrambledAudio.wav',x1,fs);