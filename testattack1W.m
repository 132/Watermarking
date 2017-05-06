cover = imread('TapAnhTest\H7.png');
%w1 = imread('jntu.bmp');
w1 = imread('IEEE64.bmp');
w1 = rgb2gray(w1);
w1 = logical(w1);

[watermarked_image, RoiMap, Uw1, Vw1, key1] = EmbedW_1(cover,w1);
p = PSNR(cover, watermarked_image);
watermarked_image = uint8(watermarked_image);

imwrite(watermarked_image,'IEEE\LENA_IEEE.bmp');
imwrite(watermarked_image,'C:\Users\My PC\Desktop\KL\implementation\stirmark\Media\Input\Images\Set1\LENA_IEEE.bmp');

[watermark_1_extracted] = watermark_extraction_1(watermarked_image, RoiMap, Uw1, Vw1, key1);
nc1 = NC(w1,watermark_1_extracted);
%nc2 = NC(w2,watermark_2_extracted);

system('"C:\Users\My PC\Desktop\KL\implementation\stirmark\Bin\Benchmark\StirMark Benchmark.exe"');

movefile('C:\Users\My PC\Desktop\KL\implementation\stirmark\Media\Output\Images\Set1','LENA_IEEE');
mkdir('C:\Users\My PC\Desktop\KL\implementation\stirmark\Media\Output\Images\','Set1');
delete('C:\Users\My PC\Desktop\KL\implementation\stirmark\Media\Input\Images\Set1\LENA_IEEE.bmp');
mkdir('LENA_IEEE','w1w2');
src = dir('LENA_IEEE\*.bmp');
fid = fopen('LENA_IEEE.txt','w');
 for i = 1:length(src)
filename = strcat('LENA_IEEE\',src(i).name);
I = imread(filename);
try
[watermark_1_extracted] = watermark_extraction_1(I, RoiMap, Uw1, Vw1, key1);
fprintf(fid,'%s\r\t ',src(i).name);
fprintf(fid,'%12.8f\r\n ',NC(w1,watermark_1_extracted));
%fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));
imwrite(watermark_1_extracted,strcat('LENA_IEEE\w1w2\W1_',src(i).name));
%imwrite(watermark_2_extracted,strcat('LENA_IEEE\w1w2\W2_',src(i).name));
catch
    disp('An error occurred while retrieving information from the internet.');
    disp('Execution will continue.');
end
end