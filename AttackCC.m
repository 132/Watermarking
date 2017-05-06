
function AttackCC()
w11 = 'Copyright in UIT';
w2 = logical(imread('boThucNghiem\IeEE64Gray.png'));

TapCover =  dir('coverDana\*.bmp');
for i = 1:length(TapCover)
    cover = strcat('coverDana\',TapCover(i).name);
    cover = imread(cover);
    [watermarked_image] = watermark_embedding(cover, w11, w2);
    
    fid = fopen(strcat('coverDana',TapCover(i).name,'.txt'),'w');
    
    w1 = encode_qr(w11, 'Character_set', 'ISO-8859-1');
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(watermarked_image);
    nc1 = NC(w1,watermark_1_extracted)
    nc2 = NC(w2,watermark_2_extracted)
    
    watermarked_image = uint8(watermarked_image);
    %average filtering
    h = fspecial('average', [15, 15]);
    meanImageAttacked = filter2(h, watermarked_image);
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(meanImageAttacked);
    
    dc = decode_qr(watermark_1_extracted);
    fprintf(fid,'average filtering\r\t ');
    
    fprintf(fid,'%12.8f\r\t ',corr2(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\t ',corr2(w2,watermark_2_extracted));
    if dc
        fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));

    %motion blur
    LEN = 21;
    THETA = 11;
    PSF = fspecial('motion', LEN, THETA);
    blurred = imfilter(watermarked_image, PSF, 'conv', 'circular');
    %[watermark_1_extracted] = watermark_extraction_1(blurred, RoiMap, Uw1, Vw1, key1);
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(blurred);
    dc = decode_qr(watermark_1_extracted);
    fprintf(fid,'motion blur\r\t ');
    fprintf(fid,'%12.8f\r\t ',corr2(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\t ',corr2(w2,watermark_2_extracted));
    if dc
        fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));

    %hisogram equa
    histogram = histeq(watermarked_image);
    %[watermark_1_extracted] = watermark_extraction_1(histogram, RoiMap, Uw1, Vw1, key1);
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(histogram);
    
    dc = decode_qr(watermark_1_extracted);
    fprintf(fid,'hisogram equa\r\t ');
    fprintf(fid,'%12.8f\r\t ',corr2(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\t ',corr2(w2,watermark_2_extracted));
    if dc
        fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));

    %median fileter
    medianfilter = medfilt2(watermarked_image,[15 15]);
    %[watermark_1_extracted] = watermark_extraction_1(medianfilter, RoiMap, Uw1, Vw1, key1);
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(medianfilter);
    dc = decode_qr(watermark_1_extracted);
    fprintf(fid,'median fileter\r\t ');
    fprintf(fid,'%12.8f\r\t ',corr2(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\t ',corr2(w2,watermark_2_extracted));
    if dc
        fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));

    %Sharpen
    temp = uint8(watermarked_image);
    SH = Sharpen(temp);
    %[watermark_1_extracted] = watermark_extraction_1(SH, RoiMap, Uw1, Vw1, key1);
    
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(SH);
    dc = decode_qr(watermark_1_extracted);
    fprintf(fid,'Sharpen\r\t ');
    fprintf(fid,'%12.8f\r\t ',corr2(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\t ',corr2(w2,watermark_2_extracted));
    if dc
        fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));

    %resize
    reimg = imresize(watermarked_image,[64 64]);
    reimg = imresize(reimg,[512 512]);
    %[watermark_1_extracted] = watermark_extraction_1(reimg, RoiMap, Uw1, Vw1, key1);
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(reimg);
    dc = decode_qr(watermark_1_extracted);
    fprintf(fid,'resize\r\t ');
    fprintf(fid,'%12.8f\r\t ',corr2(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\t ',corr2(w2,watermark_2_extracted));
    if dc
       fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));

    %rotation 
    rotationImageAttacked = imrotate(watermarked_image, 70, 'crop');
    %[watermark_1_extracted] = watermark_extraction_1(rotationImageAttacked, RoiMap, Uw1, Vw1, key1);
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(rotationImageAttacked);
    dc = decode_qr(watermark_1_extracted);
    fprintf(fid,'rotation\r\t ');
    fprintf(fid,'%12.8f\r\t ',corr2(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\t ',corr2(w2,watermark_2_extracted));
    if dc
       fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));

    %contrast adjustment
    contrastImage = imadjust(watermarked_image, [0 0.8], [0 1]);
    %[watermark_1_extracted] = watermark_extraction_1(contrastImage, RoiMap, Uw1, Vw1, key1);
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(contrastImage);
    dc = decode_qr(watermark_1_extracted);
    fprintf(fid,'contrast adjustment\r\t ');
    fprintf(fid,'%12.8f\r\t ',corr2(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\t ',corr2(w2,watermark_2_extracted));
    if dc
       fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));
    
    %CROP Attack
    test= crop(cover,4);
    %[watermark_1_extracted] = watermark_extraction_1(contrastImage, RoiMap, Uw1, Vw1, key1);
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(test);
    dc = decode_qr(watermark_1_extracted);
    fprintf(fid,'Crop1/4\r\t ');
    fprintf(fid,'%12.8f\r\t ',corr2(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\t ',corr2(w2,watermark_2_extracted));
    if dc
       fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));
    
    %JPEG Attack
    imwrite(watermarked_image,strcat('C:\Users\Administrator\Desktop\MyWork\stirmark\Media\Input\Images\Set1\',TapCover(i).name));
    cd 'C:\Users\Administrator\Desktop\MyWork\stirmark\Bin\Benchmark\';
    system('"C:\Users\Administrator\Desktop\MyWork\stirmark\Bin\Benchmark\StirMark Benchmark.exe"');
    cd 'C:\Users\Administrator\Desktop\MyWork\RIVF''2014\HanXin';

    %movefile('C:\Users\Administrator\Desktop\MyWork\stirmark\Media\Output\Images\Set1',TapCover(i).name);
    %mkdir('C:\Users\Administrator\Desktop\MyWork\stirmark\Media\Output\Images','Set1');
    delete(strcat('C:\Users\Administrator\Desktop\MyWork\stirmark\Media\Input\Images\Set1\',TapCover(i).name));
    
    sp = strsplit(TapCover(i).name,'.bmp');
    
    testName = strcat('C:\Users\Administrator\Desktop\MyWork\stirmark\Media\Output\Images\Set1\',sp{1},'_JPEG_20.bmp');
    test = imread(testName);
   
    %[watermark_1_extracted] = watermark_extraction_1(contrastImage, RoiMap, Uw1, Vw1, key1);
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(test);
    dc = decode_qr(watermark_1_extracted);
    fprintf(fid,'JPEG 20\r\t ');
    fprintf(fid,'%12.8f\r\t ',corr2(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\t ',corr2(w2,watermark_2_extracted));
    if dc
       fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));

end
end