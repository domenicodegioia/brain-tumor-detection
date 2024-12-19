function [metrics] = show_results(i, img, brain, tumor_mask, trueMask, varargin)

%SHOW_RESULTS Summary of this function goes here
%   Detailed explanation goes here


verbose = false;
if ~isempty(varargin)
    verbose = varargin{1};
end


% compute stats
jaccard_value = jaccard(tumor_mask, trueMask);
dice_value = dice(tumor_mask, trueMask);
bfscore_value = bfscore(tumor_mask, trueMask);
metrics.jaccard = jaccard_value;
metrics.dice = dice_value;
metrics.bfscore = bfscore_value;


% output
if (verbose == true)
    % print results
    fprintf('\nFigure:\t %i\n', i);
    fprintf('jaccard: %.4f\n', metrics.jaccard);
    fprintf('dice:\t %.4f\n', metrics.dice);
    fprintf('bfscore: %.4f\n', metrics.bfscore);


    figure('Units','normalized','OuterPosition',[0.1 0.1 0.8 0.8], ...
        'Name','RESULTS');

    % immagine originale
    subplot(1,3,1), imshow(img, []), title('original image')

    % risultato ottenuto
    subplot(1,3,2), imshow(brain, []), title('segmentation');
    tumor_contour = bwperim(tumor_mask);
    hold on;
    [rows, cols] = find(tumor_contour);
    plot(cols, rows, 'r.', 'MarkerSize', 1);
    hold off;
    
    % Ground Truth
    subplot(1,3,3), imshow(img, []), title('Ground Truth');
    tumor_contour = bwperim(trueMask);
    hold on;
    [rows, cols] = find(tumor_contour);
    plot(cols, rows, 'r.', 'MarkerSize', 1);
    hold off;
end

end
