function out = pulsewav1(t,T1,D)

out = zeros(size(t));

T=T1;
if length(T)~=length(t)
    T = ones(size(t)).*T1;
end

t1 = zeros(size(t));
for j=1:length(T)
    t1(j) = rem(t(j),T(j));
end

for i=1:length(t1)
    if t1(i)<(D*T(i))
        out(i) = 1;
    else
        out(i) = 0;
    end
end

