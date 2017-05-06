function y = averagefiter(img,tyle)
filtered = imfilter(double(img), ones(tyle) / (tyle*tyle), 'replicate');
y = uint8(filtered);
