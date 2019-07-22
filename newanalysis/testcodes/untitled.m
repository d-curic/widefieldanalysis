fs = 1000;
t = (0:1/fs:500)';

x = chirp(t,180,t(end),220) + 0.15*randn(size(t));

idx = floor(length(x)/6);
x(1:idx) = x(1:idx) + 0.05*cos(2*pi*t(1:idx)*210);

[sp,fp,tp] = pspectrum(x,fs,'spectrogram', ...
    'FrequencyLimits',[100 290],'TimeResolution',1, 'OverlapPercent',0);

figure(1)
mesh(tp,fp,sp)
%view(-15,60)
xlabel('Time (s)')
ylabel('Frequency (Hz)')

figure(2)
plot(sum(sp(3)))