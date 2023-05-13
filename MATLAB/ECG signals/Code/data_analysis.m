clear all; clc;

%load the ideal ECG
file = load("hirumi_22_LD2.mat");
data_ideal = file.data(:,1); %CH 1 , ideal
data_printed = file.data(:,2); %CH 2 , printed

%select a portion
fs= 500; %500samples/second
portion_start = 20 ;
portion_end = 30 ;
y_ideal = data_ideal(portion_start*fs + 1: portion_end*fs + 1 , 1);
y_printed = data_printed(portion_start*fs + 1: portion_end*fs + 1 , 1);

% %normalize the signals
y_ideal  = y_ideal - mean(y_ideal);
y_printed  = y_printed - mean(y_printed);

%measure signal time and number of samples
N = length(y_ideal); % Number of points
t = linspace(0,(N-1)/fs,N); % Time vector


%plot complete signal
figure
plot(t,y_ideal);
hold on
plot(t,y_printed , 'r');
hold off
legend("y_i","y_p");
title("Signals in time domain");
xlabel("time(ms))");
ylabel("Amplitude(mV)");

%plot 2 cycle signal
figure;
plot(t(2000:3000),y_ideal(2000:3000));
hold on
plot(t(2000:3000),y_printed(2000:3000) , 'r');
hold off
legend("y_i","y_p");
title("Signals in time domain");
xlabel("time(ms))");
ylabel("Amplitude(mV)");


%MSE calculate
mse = immse(y_ideal , y_printed);
fprintf("Results for 22mm-hirumi electrodes\n");
fprintf("===========================\n\n");
fprintf("MSE : %.7f \n"  , mse );

%SNR Calculate
snr = snr(y_printed , y_ideal - y_printed);
fprintf("SNR : %.3fdB \n"  , snr );

%PSNR calculate
%peaksnr = psnr(y_ideal , y_printed);
%fprintf("PSNR : %ddB \n"  , psnr );
 
%MAE error
%mae = mean(abs(data_ecg_ref , data_ecg));
e = y_ideal - y_printed;
perf = mae(e);
fprintf("MAE : %.3f \n"  , perf );

%cross corrilation
corr = xcorr(y_ideal ,y_printed,'normalized');
figure;
plot(corr);
title("Cross correlation(y_i , y_p)");
fprintf("Correlation : %.3f%%\n"  , max(corr)*100 );

%Coherance 
[cxy,f] = mscohere(y_ideal,y_printed,[],[],[],fs);
figure;
plot(f,cxy);
xlabel("Frequency(Hz)");
ylabel("Magnitude(0 - 1)");
title("Coherance(y_i , y_p)");


xdft_i = fft(y_ideal);
xdft_p = fft(y_printed);

xdft_i = xdft_i(1:(N/2+1));
xdft_p = xdft_p(1:(N/2+1));

psdx_i = (1/(fs*N)) * abs(xdft_i).^2;
psdx_p = (1/(fs*N)) * abs(xdft_p).^2;

psdx_i(2:end-1) = 2*psdx_i(2:end-1);
psdx_p(2:end-1) = 2*psdx_p(2:end-1);

freq = 0:fs/length(y_ideal):fs/2;

figure;
plot(freq,pow2db(psdx_i));
hold on;
plot(freq,pow2db(psdx_p));
hold off;
title("Periodogram Using FFT");
xlabel("Frequency (Hz)");
ylabel("Power/Frequency (dB/Hz)");
legend("ideal" , "printed");


