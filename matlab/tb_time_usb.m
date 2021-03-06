clear
clc
%% constant definition
MEMWORD = 512;
PARALLELISM = 2;
FIXED = 0; %used to show or not the fixed value representation of the number
%% import data
% store the time taken by each run
tb_time = [];
% run the testbench for all the possible k
for k_val= 1:1:16
data = importdata('derm_rand.mat');
tr_size = floor(size(data,1)*2/3);
tb_size = size(data,1) - tr_size;
%set the training size
tr_size = 35;
class = data(1:tr_size,end);
tb_class = data(tr_size+1:tr_size+tb_size,end);
data(:,end) = [];
% get the number of features
features = size(data,2);
% constant used for the normalization
% cancer        0.1
% dermatology   0.17
% iris          0.7

% normalization
for i= 1:1:features
    data(:,i) = 0.17*(data(:,i) - mean(data(:,i))/sqrt(var(data(:,i))));
end
% define the training and the testbench data
training = data(1:tr_size,:);
testbench = data(tr_size+1:end,:);
% if FIXED is enabled compute the fixed point representation of the data
if (FIXED == 1)
    for i = 1:1:tr_size
        for k = 1:1:features
            training_fx(i,k) = fi(training(i,k),true,10,6);
        end
    end
    for i = 1:1:tb_size
        for k = 1:1:features
            testbench_fx(i,k) = fi(testbench(i,k),true,10,6);
        end
    end
end
%% evaluation of the matlab built in function
% class obtained with the matlab built in function
cl_mat = zeros(tb_size,1);
profile on
for i = 1:1:tb_size
    query = testbench(i,:);
    cl_mat(i) = knnclassify(query,training,class,k_val,'euclidean');

end
% profile viewer
p = profile('info');
hexval = [];
row = [];
padding = [];
c = 0;
k = 1;
if(k_val == 1)
%% flush the sdram
fileId = fopen('flush.dat','w');
% fill the file with the training data in hex
for i = 1:1:tr_size
    hexval =[hexval; bin2hex(bin(fi(class(k),false,32,0)))];
    fprintf(fileId,'%s\n', bin2hex(bin(fi(class(k),false,32,0))));
    k = k + 1;
    row = training(i,:);
    padding = zeros(1,3-mod(features,3));
    row = [row padding];
    c = 0;
    for j = 1:1:ceil(features/3)
        hexval =[hexval; bin2hex(strcat(bin(fi(row(c+3),true,10,6)),bin(fi(row(c+2),true,10,6)),bin(fi(row(c+1),true,10,6))))];
        if(i == tr_size && j == ceil(features/3))
            fprintf(fileId,'%s',bin2hex(strcat(bin(fi(row(c+3),true,10,6)),bin(fi(row(c+2),true,10,6)),bin(fi(row(c+1),true,10,6)))));
        else
            fprintf(fileId,'%s\n',bin2hex(strcat(bin(fi(row(c+3),true,10,6)),bin(fi(row(c+2),true,10,6)),bin(fi(row(c+1),true,10,6)))));    
        end
        c = c + 3;    
    end
end
fclose(fileId);
% send the command to the FPGA
flush_sdram(features,MEMWORD);
% pause neeeded to avoid the lock of the USB port
pause(2);
end;
%% send the queries to the accelerator
distance = zeros(tr_size,3);
% matrix to store all the result
result = zeros(tb_size,2*k_val+2);
tot_time = 0.0;
pause(2);
if (k_val == 1)
fileId = fopen('query.dat','w');
% fill the file with all the query vector in hex
for i= 1:1:tb_size
    row = testbench(i,:);
    padding = zeros(1,3-mod(features,3));
    row = [row padding];
    c = 0;
    hexvalq = [];
    for j = 1:1:ceil(features/3)
        hexvalq =[hexvalq; bin2hex(strcat(bin(fi(row(c+3),true,10,6)),bin(fi(row(c+2),true,10,6)),bin(fi(row(c+1),true,10,6))))];
        if(j == ceil(features/3) && i == tb_size)
            fprintf(fileId,'%s',bin2hex(strcat(bin(fi(row(c+3),true,10,6)),bin(fi(row(c+2),true,10,6)),bin(fi(row(c+1),true,10,6)))));
        else
            fprintf(fileId,'%s\n',bin2hex(strcat(bin(fi(row(c+3),true,10,6)),bin(fi(row(c+2),true,10,6)),bin(fi(row(c+1),true,10,6)))));    
        end
        c = c + 3;    
    end
end  
fclose(fileId);
end;
% send the command for the classification and save the result
cl_ans = class_command(features,tr_size,ceil(features/3),tb_size,k_val,PARALLELISM,MEMWORD);
fprintf('Done\n');
acc_time = uint32(0);

%% parsing the result
for i = 1:1:tb_size
    result(i,k_val+1) = cl_ans(1,i);
    for k_v = 1:1:k_val
        result(i,k_v) = conv_dist(dec2hex(cl_ans(7+k_v,i),4));
    end
    distance = zeros(tr_size,3);
    % compute the distance and class to have the correct values in the matrix of the result to make a comparison
    for h= 1:1:tr_size
        sum = 0;
        for k = 1:1:features
            if(FIXED == 1)
                sum = sum + fi((fi(training_fx(h,k)-testbench_fx(i,k),true,10,6))^2,false,16,9);
            else
                sum = sum + (training(h,k)-testbench(i,k))^2;
            end
        end
        distance(h,1) = i;
        distance(h,2) = fi(sum,false,16,9);
        distance(h,3) = tb_class(i);
    end
    k_nn = sortrows(distance,2);
    result(i,k_val+2:2*k_val+1) = k_nn(1:k_val,2)'; 
    result(i,end) = cl_mat(i);
    % get the time taken by the accelerator
    acc_time = uint32(cl_ans(4,i));
    acc_time = bitshift(acc_time,-16);
    acc_time = acc_time + uint32(cl_ans(3,i));
    tot_time = tot_time + acc_time/144;
end

%% show the result
% save the time of the accelerator and the time of matlab in us
tb_time(k_val,1) = double(tot_time)/double(tb_size);
tb_time(k_val,2) = p.FunctionTable(1,1).TotalTime/double(tb_size)*1e6;
end                             