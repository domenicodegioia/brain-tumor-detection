close all, clear, clc
set(groot, 'DefaultAxesFontSize', 20);
set(groot, 'DefaultTextFontSize', 20);


% Caricamento dell'immagine MRI
data = load('test/20.mat');
cjdata = data.cjdata;
img = cjdata.image;
tumorBorder = cjdata.tumorBorder;
tumorMask = cjdata.tumorMask;


figure('Units','normalized','OuterPosition',[0 0 1 1],'Name','MASCHERA BINARIA');
subplot(2,5,1), imshow(img, []), title('originale')


% Fase 1: Preprocessing
% median filter
medianImg = medfilt2(img, [5 5]); % per ridurre il rumore impulsivo
subplot(2,5,2), imshow(medianImg, []), title('median filter')
% gaussian filter
smoothedImg = imgaussfilt(medianImg, 0.5);
subplot(2,5,3), imshow(smoothedImg, []), title('gaussian filter')


% Fase 2: background mask
% sobel operator
sobelX = fspecial('sobel');
sobelY = sobelX';
gradX = imfilter(double(smoothedImg), sobelX, 'replicate');
gradY = imfilter(double(smoothedImg), sobelY, 'replicate');
sobelImg = sqrt(gradX.^2 + gradY.^2);
sobelImg = uint8(sobelImg);
subplot(2,5,4), imshow(sobelImg), title('sobel')
% thresholding
threshold_value = graythresh(sobelImg);
binary_img = imbinarize(sobelImg, threshold_value);
subplot(2,5,5), imshow(binary_img), title('thresholding')
% morphological operations
se = strel('disk', 1);
binary_opened = imopen(binary_img, se);
subplot(2,5,6), imshow(binary_opened), title('apertura')
binary_closed = imclose(binary_opened, se);
subplot(2,5,7), imshow(binary_closed), title('chiusura')
binary_filled = imfill(binary_closed,  "holes");
subplot(2,5,8), imshow(binary_filled), title('riempimento buchi')
binary_mask = bwareaopen(binary_filled,1000);
subplot(2,5,9), imshow(binary_mask), title('rimozione oggetti piccoli')
subplot(2,5,10), imshow(binary_mask), title('binary mask')


% Fase 3: brain isolation
% isolamento del cranio
figure('Units','normalized','OuterPosition',[0 0 1 1],'Name','SKULL STRIPPING');
subplot(2,5,1), imshow(img, []), title('immagine originale')
eq_img = histeq(smoothedImg);
subplot(2,5,2), imshow(eq_img, []), title('histeq')
subplot(2,5,3), imshow(binary_mask, []), title('binary mask')
skull = double(eq_img) .* double(binary_mask);
skull = uint16(skull);
skull = imclearborder(skull);
subplot(2,5,4), imshow(skull,[]), title('no background')
% thresholding
threshold = graythresh(skull);
binary = imbinarize(skull, threshold);
subplot(2,5,5), imshow(binary), title('thresholding')
% morphological operations
se = strel('disk', 7);
binary_eroded = imerode(binary, se);
subplot(2,5,6), imshow(binary_eroded), title('erosion')
binary_dilated = imdilate(binary_eroded, se);
subplot(2,5,7), imshow(binary_dilated), title('dilation')
% componente connessa più grande
CC = bwconncomp(binary_eroded);
numPixels = cellfun(@numel, CC.PixelIdxList);
[~, idx] = max(numPixels);
brain_mask = false(size(binary_eroded));
brain_mask(CC.PixelIdxList{idx}) = true;
brain_mask = imfill(brain_mask,  "holes");
subplot(2,5,8), imshow(brain_mask), title('brain mask')
% brain isolation
brain = double(img) .* double(brain_mask);
brain = uint16(brain);
brain = imclearborder(brain);
subplot(2,5,9), imshow(brain,[]), title('Skull-Stripped Brain')


% Fase 4: tumor segmentation
figure('Units','normalized','OuterPosition',[0 0 1 1],'Name','TUMOR SEGMENTATION');
subplot(2,5,1), imshow(img, []), title('originale')
subplot(2,5,2), imshow(brain_mask), title('brain mask')
subplot(2,5,3), imshow(brain,[]), title('Skull-Stripped Brain')
% thresholding (non zero values)
nonZeroValues = brain(brain > 0);
threshold = graythresh(nonZeroValues);
tumor_binary = imbinarize(brain, threshold);
subplot(2,5,4), imshow(tumor_binary,[]), title('thresholding')
% morphological operations
tumor_binary_cleaned = bwareaopen(tumor_binary, 20);
subplot(2,5,5), imshow(tumor_binary_cleaned,[]), title('rimozione oggetti piccoli')
tumor_binary_eroded = imerode(tumor_binary_cleaned, se);
subplot(2,5,6), imshow(tumor_binary_eroded), title('erosion')
tumor_binary_dilated = imdilate(tumor_binary_eroded, se);
subplot(2,5,7), imshow(tumor_binary_dilated), title('dilation')
tumor_mask = imfill(tumor_binary_dilated, "holes");
subplot(2,5,8), imshow(tumor_mask), title({'tumor mask', '(riempimento buchi)'})
% isolazione del tumore
tumor_extracted = double(img) .* double(tumor_mask);
tumor_extracted = uint16(tumor_extracted);
tumor_extracted = imclearborder(tumor_extracted);
subplot(2,5,9), imshow(tumor_extracted,[]), title('tumor')
% perimetro del tumore
tumor_contour = bwperim(tumor_mask);
subplot(2,5,10), imshow(img, []), title('perimetro');
hold on;
[rows, cols] = find(tumor_contour);
plot(cols, rows, 'r.', 'MarkerSize', 1);
hold off;


% CONFRONTO
figure('Units','normalized','OuterPosition',[0 0 1 1],'Name','CONFRONTO');
% immagine originale
subplot(1,3,1), imshow(img, []), title('immagine originale')
% risultato ottenuto
subplot(1,3,2), imshow(img, []), title('risultato ottenuto');
hold on;
[rows, cols] = find(tumor_contour);
plot(cols, rows, 'r.', 'MarkerSize', 1);
hold off;
% Ground Truth
subplot(1,3,3), imshow(img, []), title('Ground Truth');
hold on;
borderX = tumorBorder(1:2:end);
borderY = tumorBorder(2:2:end);
plot(borderX, borderY, 'r-', 'LineWidth', 2);