clc; 
clear; 
close all;

nombre_archivo = '100.dat'; 
Fs = 360; ganancia = 200;

fid = fopen(nombre_archivo, 'r');
datos = fread(fid, [3, inf], 'uint8')'; fclose(fid);

M = datos(:,2);
sig2 = datos(:,3) + 256 * bitshift(M, -4);
sig2(sig2 > 2047) = sig2(sig2 > 2047) - 4096;
ecg_raw = sig2 / ganancia;
t = (0:length(ecg_raw)-1) / Fs;

% FILTRO PASA-ALTO (Quitar la Respiración)
% Cortamos lo que está por debajo de los 0.5 Hz
[b_hp, a_hp] = butter(3, 0.5/(Fs/2), 'high');
ecg_hp = filtfilt(b_hp, a_hp, ecg_raw);

% FILTRO PASA-BAJO (Quitar Ruido de Músculos)
% Cortamos lo que esté por encima de 40 Hz
[b_lp, a_lp] = butter(4, 40/(Fs/2), 'low');
ecg_filt = filtfilt(b_lp, a_lp, ecg_hp);

% GRAFICAR COMPARATIVA
figure('Color', 'w');

% Señal Original
subplot(2,1,1);
plot(t, ecg_raw, 'k');
xlim([100 105]); % Miramos 5 segundos en la mitad
title('ECG Original (Con ruido y deriva de línea base)');
ylabel('Amplitud (mV)');
grid on;

% Señal Filtrada
subplot(2,1,2);
plot(t, ecg_filt, 'r', 'LineWidth', 1);
xlim([100 105]);
title('ECG Filtrado (Pasa-Alto 0.5Hz + Pasa-Bajo 40Hz)');
ylabel('Amplitud (mV)');
xlabel('Tiempo (s)');
grid on;