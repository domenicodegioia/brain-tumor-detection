function [img_enhanced] = preprocessing(img, varargin)

%PREPROCESSING Summary of this function goes here
%   Detailed explanation goes here


verbose = false;
if ~isempty(varargin)
    verbose = varargin{1};
end


img = rescale(img);
img = im2uint8(img);
img = imresize(img, [512 512]);


% sharpening
img_sharpen = imsharpen(img);
% median filter
img_median = medfilt2(img_sharpen, [3 3]);
% gaussian filter
img_smoothed = imgaussfilt(img_median, 0.5);
% contrast adjustment
img_enhanced = imadjust(img_sharpen,stretchlim(img_sharpen),[]);


% output
if (verbose == true)
    figure('Units','normalized','OuterPosition',[0.1 0.1 0.8 0.8], ...
        'Name','PREPROCESSING');
    subplot(1,5,1), imshow(img), title('originale')
    subplot(1,5,2), imshow(img), title('sharpening')
    subplot(1,5,3), imshow(img_median), title('median filter')
    subplot(1,5,4), imshow(img_smoothed), title('gaussian filter')
    subplot(1,5,5), imshow(img_enhanced), title('contrast adjustment')
end

end