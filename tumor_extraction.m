function [binary_mask, tumor] = tumor_extraction(img, brain, varargin)

%TUMOR_EXTRACTION Summary of this function goes here
%   Detailed explanation goes here


verbose = false;
if ~isempty(varargin)
    verbose = varargin{1};
end


% thresholding
thr = 125;
binary = brain > thr;


% morphological operations
se = strel('diamond', 3);
binary_eroded = imerode(binary, se);
CC = bwconncomp(binary_eroded);
numPixels = cellfun(@numel, CC.PixelIdxList);
[~, idx] = max(numPixels);
binary_comp = false(size(binary_eroded));
binary_comp(CC.PixelIdxList{idx}) = true;
binary_dilated = imdilate(binary_comp, se);
binary_mask = imfill(binary_dilated, "holes");


% brain extraction
tumor = double(brain) .* double(binary_mask);
tumor = uint8(tumor);


% output
if (verbose == true)
    figure('Units','normalized','OuterPosition',[0.1 0.1 0.8 0.8], ...
        'Name','TUMOR EXTRACTION');
    subplot(2,4,1), imshow(brain, []), title('brain')
    subplot(2,4,2), imshow(binary), title('thresholding')
    subplot(2,4,3), imshow(binary_eroded), title('erosion')
    subplot(2,4,4), imshow(binary_comp), title('bwconncomp')
    subplot(2,4,5), imshow(binary_dilated), title('dilation')
    subplot(2,4,6), imshow(binary_mask), title('filling holes')
    subplot(2,4,7), imshow(tumor), title('tumor')
    subplot(2,4,8), imshow(img, []), title('original')
end

end