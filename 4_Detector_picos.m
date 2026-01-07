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

% Filtro Pasa-Banda (0.5 - 40 Hz)
[b, a] = butter(3, [0.5 40]/(Fs/2), 'bandpass');
ecg_filt = filtfilt(b, a, ecg_raw);
t = (0:length(ecg_filt)-1) / Fs;

% DETECCIÓN DE PICOS R 
[pks, locs] = findpeaks(ecg_filt, t, ...
    'MinPeakHeight', 0.5 * max(ecg_filt), ...
    'MinPeakDistance', 0.6); 

% CÁLCULO DE FRECUENCIA CARDÍACA (BPM) 
rr_intervals = diff(locs);          
bpm_inst = 60 ./ rr_intervals;      
bpm_medio = mean(bpm_inst);         

% CONDICIÓN DE DIAGNÓSTICO 
if bpm_medio > 100
    diagnostico = 'Posible Taquicardia';
    color_alerta = [1 0 0]; % Rojo
elseif bpm_medio < 60
    diagnostico = 'Posible Bradicardia';
    color_alerta = [0 0 1]; % Azul
else
    diagnostico = 'Ritmo Normal';
    color_alerta = [0 0.5 0]; % Verde
end

% Gráfico
figure('Color', 'w');
plot(t, ecg_filt, 'Color', [0.4 0.4 0.4]); hold on; % Señal en gris
plot(locs, pks, 'ro', 'MarkerFaceColor', 'r');     % Picos en rojo
xlim([300 310]); % Mostramos un tramo de 10 segundos
title_str = sprintf('BPM: %.1f - %s', bpm_medio, diagnostico);
title(title_str, 'FontSize', 14, 'Color', color_alerta);
xlabel('Tiempo (s)'); ylabel('Voltaje (mV)');
legend('ECG Filtrado', 'Latidos detectados');
grid on;

% Consola
fprintf('\n--- RESULTADOS DEL ANÁLISIS ---\n');
fprintf('BPM Promedio: %.2f\n', bpm_medio);
fprintf('Estado: %s\n', diagnostico);
fprintf('-------------------------------\n');