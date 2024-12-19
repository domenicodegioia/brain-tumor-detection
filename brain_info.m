clear, clc

% Carica il contenuto del file .mat
filename = 'test/3.mat';
data = load(filename);
cjdata = data.cjdata;

% Estrai informazioni dalla struttura
label = cjdata.label; % Tipo di tumore
PID = cjdata.PID; % ID del paziente
imageData = cjdata.image; % Dati immagine
tumorBorder = cjdata.tumorBorder; % Coordinate del bordo del tumore
tumorMask = cjdata.tumorMask; % Maschera binaria del tumore

disp(['Patient ID: ', PID]);
disp(['Tumor Label: ', num2str(label)]);

figure('Units', 'normalized', 'OuterPosition', [0 0 1 1]);
subplot(1, 3, 1), imshow(imageData, []), title('Tumor Image', FontSize=24);

% Visualizza il bordo del tumore sull'immagine
subplot(1, 3, 2), imshow(imageData, []);
hold on;
borderX = tumorBorder(1:2:end); % Estrai le coordinate X
borderY = tumorBorder(2:2:end); % Estrai le coordinate Y
plot(borderX, borderY, 'r-', 'LineWidth', 2);
title('Tumor Border', FontSize=24);

% Visualizza la maschera binaria del tumore
subplot(1, 3, 3), imshow(tumorMask, []), title('Tumor Mask', FontSize=24);


