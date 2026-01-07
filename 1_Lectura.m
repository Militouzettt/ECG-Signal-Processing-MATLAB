clc;
clear;
close all;

% --- CONFIGURACIÓN INICIAL ---
nombre_archivo = '100.dat';
Fs = 360;            
ganancia = 200;      

% --- LECTURA DEL ARCHIVO ---
fid = fopen(nombre_archivo, 'r');
datos = fread(fid, [3, inf], 'uint8')'; 
fclose(fid);

% 212: Dos muestras en 3 bytes.
% Byte 1: Muestra 1
% Byte 2: 4 bits de muestra 1, 4 bits de muestra 2
% Byte 3: Muestra 2
M = datos(:,2);
sig1 = datos(:,1) + 256 * bitand(M, 15);    % Canal V5
sig2 = datos(:,3) + 256 * bitshift(M, -4);  % Canal MLII

% --- CONVERSIÓN DE DATOS ---
% Convertimos negativos en positivos (Complemento a 2)
% Los valores 0-2047 son positivos; 2048-4095 negativos.
% Se resta 4096 (2^12) a los valores > 2047 para obtener el valor real. 
sig1(sig1 > 2047) = sig1(sig1 > 2047) - 4096;
sig2(sig2 > 2047) = sig2(sig2 > 2047) - 4096;

% Convertir a unidades físicas (mV)
ecg_v5 = sig1 / ganancia;
ecg_mlii = sig2 / ganancia;

% --- CÁLCULO DE TIEMPO ---
N = length(ecg_v5);      
T_total = (N-1) / Fs;     
tiempo = (0:N-1) / Fs;    

% --- GENERACIÓN DE GRÁFICOS ---
figure('Color', 'w', 'Name', 'Comparativa Multicanal ECG');

% --- GRÁFICO 1: Inicio (0s - 2s) ---
subplot(3,1,1)
plot(tiempo, ecg_mlii, 'b'); hold on;
plot(tiempo, ecg_v5, 'r');
xlim([0 2])
title('Inicio: Comparativa MLII (Azul) vs V5 (Rojo)')
ylabel('Voltaje (mV)')
legend('MLII', 'V5', 'Location', 'northeast')
grid on

% --- GRÁFICO 2: Mitad (2 segundos) ---
subplot(3,1,2)
t_medio = T_total / 2;
plot(tiempo, ecg_mlii, 'b'); hold on;
plot(tiempo, ecg_v5, 'r');
xlim([t_medio, t_medio + 2])
title(['Mitad de la grabación (', num2str(round(t_medio)), 's)'])
ylabel('Voltaje (mV)')
grid on

% --- GRÁFICO 3: Final (Últimos 2 segundos) ---
subplot(3,1,3)
plot(tiempo, ecg_mlii, 'b'); hold on;
plot(tiempo, ecg_v5, 'r');
xlim([T_total - 2, T_total])
title(['Final de la grabación (', num2str(round(T_total)), 's)'])
xlabel('Tiempo (s)')
ylabel('Voltaje (mV)')
grid on