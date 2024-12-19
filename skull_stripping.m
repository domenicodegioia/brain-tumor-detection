function [binary_mask, brain] = skull_stripping(img, varargin)

%SKULL_STRIPPING Summary of this function goes here
%   Detailed explanation goes here


verbose = false;
if ~isempty(varargin)
    verbose = varargin{1};
end


% thresholding
thr = 30;
binary = img > thr;


% morphological operations
binary_cleaned = bwareaopen(binary, 100);
binary_filled = imfill(binary_cleaned, "holes");
se = strel('disk', 40);
binary_mask = imerode(binary_filled, se);


% brain extraction
brain = double(img) .* double(binary_mask);
brain = uint8(brain);


% output
if (verbose == true)
    figure('Units','normalized','OuterPosition',[0.1 0.1 0.8 0.8], ...
        'Name','SKULL STRIPPING');

    
    subplot(2,4,1), imshow(img), title('skull')
    subplot(2,4,2), imshow(binary), title('thresholding')
    subplot(2,4,3), imshow(binary_cleaned), title('remove small objects')
    subplot(2,4,4), imshow(binary_filled), title('filling holes')
    subplot(2,4,5), imshow(binary_mask), title('erosion')
    subplot(2,4,6), imshow(brain), title('brain')

end

end