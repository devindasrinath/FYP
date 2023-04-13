clear all; clc;

%load the ideal ECG
file = load("TEST_5_KULUNU_11mm_wet_cmp_LEADII_L06.mat");
data_ideal = file.data(:,1); %CH 1 , ideal
data_printed = file.data(:,2); %CH 2 , printed

% %normalize the signals
y_ideal  = data_ideal - mean(data_ideal);
y_printed  = data_printed - mean(data_printed);

%select a portion
y_ideal = y_ideal(8001: 18000 , 1);
y_printed = y_printed(8001: 18000 , 1);

%measure signal time and number of samples
N = length(y_ideal); % Number of points
t = linspace(1,N,N); % Time vector

%plot signals
plot(t,y_ideal);
hold on
plot(t,y_printed , 'r');
hold off
legend("y_i","y_p");
title("Signals in time domain");
xlabel("time(ms))");
ylabel("Amplitude(mV)");


%MSE calculate
mse = immse(y_ideal , y_printed);
fprintf("Results for 5.5mm electrodes\n");
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
cxy = mscohere(y_ideal,y_printed);
figure;
plot(cxy(1:256,1));
xlabel("Frequency(Hz)");
ylabel("Magnitude(0 - 1)");
title("Coherance(y_i , y_p)");


