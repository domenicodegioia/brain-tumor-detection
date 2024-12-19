close all, clear, clc
set(groot, 'DefaultAxesFontSize', 20);
set(groot, 'DefaultTextFontSize', 20);


for i = 3:3

    filename = strcat('test/',int2str(i),'.mat');


    data = load(filename);
    cjdata = data.cjdata;
    img = cjdata.image;
    trueMask = cjdata.tumorMask;

    
    img_enhanced = preprocessing(img, false);
    

    [brain_mask, brain] = skull_stripping(img_enhanced, false);


    [tumor_mask, tumor] = tumor_extraction(img_enhanced, brain, false);


    metrics = show_results(i, img, brain, tumor_mask, trueMask, true);


    features = extract_features(img, true);
end
