function y = ContrastAdj(originalImage)
contrastImage = imadjust(originalImage, [0 0.8], [0 1]);
y = contrastImage;