function [metrics,entropy] = extract_features(img, varargin)
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes here


verbose = false;
if ~isempty(varargin)
    verbose = varargin{1};
end


glcm = graycomatrix(img, 'Offset', [0 1], 'Symmetric', true, 'GrayLimits', []);


metrics = graycoprops(glcm, {'Contrast', 'Correlation', ...
    'Energy', 'Homogeneity'});


glcmnorm = glcm / sum(glcm(:));
entropy = -sum(glcmnorm(glcmnorm > 0) .* log(glcmnorm(glcmnorm > 0)), 'all');


% output
if (verbose == true)
    fprintf('Contrast:\t%.4f\n', metrics.Contrast);
    fprintf('Correlation:\t%.4f\n', metrics.Correlation);
    fprintf('Homogeneity:\t%.4f\n', metrics.Homogeneity);
    fprintf('Energy:\t\t%.4f\n', metrics.Energy);
    fprintf('Entropy:\t%.4f\n', entropy);
end

end