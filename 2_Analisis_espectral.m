clc; 
clear; 
close all;

nombre_archivo = '100.dat'; 
Fs = 360; 
ganancia = 200;

fid = fopen(nombre_archivo, 'r');
if fid == -1
        error('No se encuentra el archivo 100.dat'); 
end
datos = fread(fid, [3, inf], 'uint8')'; 
fclose(fid);

% Usamos señal 2
M = datos(:,2);
sig2 = datos(:,3) + 256 * bitshift(M, -4);
sig2(sig2 > 2047) = sig2(sig2 > 2047) - 4096;
ecg = sig2 / ganancia;

N = length(ecg);           % Número de muestras
X = fft(ecg);              % Transformada de Fourier
X_mag = abs(X) / N;        % Magnitud normalizada

% EJE DE FRECUENCIAS
f = (0:N-1) * (Fs / N);    % Conversión a Hertz

figure('Color', 'w');

% Subplot 1: Escala Lineal (La que se ve como "L")
subplot(2,1,1);
plot(f(1:floor(N/2)), X_mag(1:floor(N/2)), 'b');
xlim([0 100]); 
title('Espectro de Frecuencia (Escala Lineal)');
ylabel('Magnitud');
grid on;
text(5, max(X_mag)*0.8, '\leftarrow El pico de 0 Hz aplasta al resto');

% Subplot 2: Escala Logarítmica 
% Usamos 20*log10 para pasar a Decibelios (dB)
subplot(2,1,2);
plot(f(1:floor(N/2)), 20*log10(X_mag(1:floor(N/2))), 'r');
xlim([0 100]);
title('Espectro de Frecuencia (Escala en dB - ¡Aquí se ve todo!)');
xlabel('Frecuencia [Hz]');
ylabel('Magnitud [dB]');
grid on;

% Anotaciones
hold on;
plot(60, -50, 'ko', 'MarkerSize', 10); % Marca en 60 Hz
text(62, -45, 'Ruido de red (60 Hz)');