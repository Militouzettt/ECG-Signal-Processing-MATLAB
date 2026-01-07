Procesamiento y Análisis de Señales ECG (MIT-BIH)
Este repositorio contiene un pipeline desarrollado en MATLAB para la lectura, el análisis frecuencial, el filtrado digital y la detección de parámetros clínicos de señales electrocardiográficas provenientes de la base de datos MIT-BIH.

Descripción del Proyecto
El objetivo es transformar datos binarios crudos (Formato 212) en información médica procesada, aplicando técnicas de procesamiento digital de señales y criterios de diagnóstico clínico.

Estructura del Proyecto
1. Lectura y Decodificación (Lectura.m)
Decodificación binaria de datos en Formato 212 (3 bytes para 2 muestras de 12 bits).

Visualización comparativa de las derivaciones MLII y V5.

Ajuste por complemento a 2 y escalado a milivoltios (mV) mediante la ganancia del sensor.

2. Análisis Espectral (Analisis_espectral.m)
Implementación de la Transformada Rápida de Fourier (FFT) para identificar componentes frecuenciales.

Identificación de interferencia de red (60 Hz) y deriva de la línea base mediante visualización en escala logarítmica (dB).

3. Filtrado Digital (Filtrado.m)
Filtro Pasa-Alto (0.5 Hz): Eliminación del ruido respiratorio (Baseline Wander).

Filtro Pasa-Bajo (40 Hz): Atenuación de ruido muscular e interferencia eléctrica.

Uso de la función filtfilt para asegurar un filtrado de fase cero, preservando la alineación temporal de los complejos QRS.

4. Detección y Diagnóstico (Detector_Picos.m)
Localización automática de picos R basada en umbrales de amplitud y distancia temporal.

Cálculo de la frecuencia cardíaca promedio (BPM) mediante la medición de intervalos R-R.

Clasificación automática del estado del paciente: Taquicardia (>100 BPM), Bradicardia (<60 BPM) o Ritmo Normal.

Requisitos
MATLAB.

Archivos de datos de la base de datos MIT-BIH Arrhythmia Database (ejemplo: 100.dat).

Instrucciones de Uso
Colocar los archivos de datos (.dat) en el mismo directorio que los scripts.

Ejecutar los scripts en orden correlativo para observar el procesamiento desde la señal cruda hasta el diagnóstico.
Desarrollado por: Luciana Milagros Touzet

Carrera: Ingeniería Biomédica
