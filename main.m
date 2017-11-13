%%% part 1: acquire the musical note

% recObj = audiorecorder;
% disp("Start recording.");
% recordblocking(recObj, 6);
% disp("End of Recording.");

recObj = recObj3;
% play(recObj);
soundArray = getaudiodata(recObj);

%%% part 2: calculate fundamental frequency and period of note A4
plot(soundArray);
x1 = 22893;
x2 = 22911;

freq = 8000 / (x2 - x1);
period = 1 / freq;

partOfSoundArray = soundArray(9813:25370);
partOfSoundArray = partOfSoundArray(11360:15290);
plot(partOfSoundArray);

%%% part 3: calculate fourier series coefficients
firstPeriodUpperBound = cast(period * 8000, 'int8');

firstPeriodOfPartOfSoundArray = partOfSoundArray(1:firstPeriodUpperBound+1);
plot(firstPeriodOfPartOfSoundArray);
t = 0:1/8000:period;
t_t = t.';

k = 7;
fcd = zeros(2*k+1, 1);
for m = -k:k
    fcd(m+k+1) = (trapz(t_t, exp(-1i*2*pi/period*m.*t_t)*1/period.*firstPeriodOfPartOfSoundArray));
end

x_f = linspace(-k, k, 2*k+1);
y = abs(fcd);
plot(x_f, y);
title('Fourier Series Coefficients of Recorded Signal');
xlabel('k');
ylabel('a(k)');

%%% part 4: fourier series synthesis
x = zeros(19,1);
for m = 1:2*k+1
    y = fcd(m)*exp((-1i*2*pi/period)*(m-k-1)*t_t);
    x = x+y;
end

plot(abs(x));
xlabel('n');
ylabel('Magnitude');
title('Fourier Synthesis of Signal');

%%% part 5: voice file generation
w_signal = repmat(x, 200, 1);
audiowrite('fourierSynthesis.wav', abs(w_signal), 8000);
audiowrite('original.wav', abs(partOfSoundArray), 8000);

%%% part 6: synthesis from partial fourier coefficients
for j = 0:6
    x = zeros(19,1);
    for m = (8-j):(8+j)
        y = fcd(m)*exp((-1i*2*pi/period)*(m-k-1)*t_t);
        x = x+y;
    end
    audiowrite(strcat('synthesis', num2str(j), '.wav'), abs(x), 8000);
end

%%% part 7: Synthesis of theVoice fromFourier SeriesCoefficients
%%% whoseMagnitudes are equated to one
equated_fcd = zeros(2*k+1, 1);
for j = 1:2*k+1
    equated_fcd(j) = fcd(j) / abs(fcd(j));
end

x = zeros(19,1);
for m = 1:2*k+1
    y_t = equated_fcd(m)*exp((-1i*2*pi/period)*(m-k-1)*t_t);
    x = x+y_t;
end
audiowrite('equated.wav', repmat(abs(x), 200, 1), 8000);

%%% part 8: Synthesis of the Voice from Fourier Series Coefficients whose Phases
%%% are equated to zero
absolute_fcd = zeros(15, 1);
for j = 1:15
    absolute_fcd(j) = abs(fcd(j));
end
x = zeros(19,1);
for m = 1:2*k+1
    y = equated_fcd(m)*exp((-1i*2*pi/period)*(m-k-1)*t_t);
    x = x+y;
end
audiowrite('zeroed.wav', repmat(abs(x), 200, 1), 8000);

% dcmObj = datacursormode;
% set(dcmObj,'UpdateFcn',@NewCallback);



