function d = conv_dist(hex)
row = [dec2bin(hex2dec(hex(1)),4) dec2bin(hex2dec(hex(2)),4) dec2bin(hex2dec(hex(3)),4) dec2bin(hex2dec(hex(4)),4)];
sum = 0;
for i = 1:1:16
    row(i);
    pow = 2^(6-i+1);
    sum = sum + str2num(row(i))*pow;
end
d = sum;
end