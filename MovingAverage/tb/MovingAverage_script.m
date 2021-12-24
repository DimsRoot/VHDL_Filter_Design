clear all;
clc;

FILT_DEPTH = 16;  # Nb of sample used for the filtre 
ADC_RES    = 16;  # Width in bit of the input (16-bits ADC for ex)

x = randi([0 pow2(ADC_RES)-1],100,1);
y = floor(filter(ones(1,FILT_DEPTH)/FILT_DEPTH,1,x));


fid = fopen('ADC_sample.dat','wt');
for i = 1:length(x)
    fprintf(fid,'%i\n',x(i));
end;
fclose(fid);

fid = fopen('ADC_sample_filtered.dat','wt');
for i = 1:length(y)
    fprintf(fid,'%i\n',y(i));
end;
fclose(fid);