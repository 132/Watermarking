%cover = imread('TapAnhTest\lena.png');
%w2 = imread('tapAnhTest\IEEE64.bmp');
%w1 = 'Copyright in UIT';
function testAttack()

w2 = logical(imread('BoThucNghiem\IEEE64Gray.png'));
w11 = 'Copyright in UIT';

w1 = encode_qr(w11, 'Character_set', 'ISO-8859-1');

TapCover = dir('cover\*.bmp');
for i = 1:length(TapCover)
    cover = imread(strcat('cover\',TapCover(i).name));
        
    [watermarked_image] = watermark_embedding(cover, w11, w2);
    p = PSNR(cover, watermarked_image);
    watermarked_image = uint8(watermarked_image);
    
    
    imwrite(watermarked_image,strcat('watermarked_image\',TapCover(i).name));
    imwrite(watermarked_image,strcat('C:\Users\Administrator\Desktop\MyWork\stirmark\Media\Input\Images\Set1\',TapCover(i).name));

    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(watermarked_image);
    nc1 = NC(w1,watermark_1_extracted);
    nc2 = NC(w2,watermark_2_extracted);

    fid = fopen(strcat(TapCover(i).name,'.txt')','w');
    fprintf(fid,'%12.8f\r\t ',p);
    fprintf(fid,'%12.8f\r\t ',nc1);
    QR = decode_qr(watermark_1_extracted)
    if QR
        fprintf(fid,'Rut duoc %s\r\t',QR);
    end
    fprintf(fid,'%12.8f\r\n ',nc2);
    
cd 'C:\Users\Administrator\Desktop\MyWork\stirmark\Bin\Benchmark\';
system('"C:\Users\Administrator\Desktop\MyWork\stirmark\Bin\Benchmark\StirMark Benchmark.exe"');
cd 'C:\Users\Administrator\Desktop\MyWork\RIVF''2014\HanXin';

movefile('C:\Users\Administrator\Desktop\MyWork\stirmark\Media\Output\Images\Set1',TapCover(i).name);
mkdir('C:\Users\Administrator\Desktop\MyWork\stirmark\Media\Output\Images','Set1');
delete(strcat('C:\Users\Administrator\Desktop\MyWork\stirmark\Media\Input\Images\Set1\',TapCover(i).name));

    mkdir(TapCover(i).name,'w1w2');
    src = dir(strcat(TapCover(i).name,'\*.bmp'));
    

    for j = 1:length(src)
    filename = strcat(TapCover(i).name,'\',src(j).name);
    I = imread(filename);
    try
    [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(I);
    
    fprintf(fid,'%s\r\t ',src(j).name);
    fprintf(fid,'%12.8f\r\t ',NC(w1,watermark_1_extracted));
    if decode_qr(watermark_1_extracted)
        fprintf(fid,'Rut duoc %s\r\t',decode_qr(watermark_1_extracted));
    end
    fprintf(fid,'%12.8f\r\n ',NC(w2,watermark_2_extracted));
   
    imwrite(watermark_1_extracted,strcat(TapCover(i).name,'\w1w2\W1_',src(j).name,'.png'));
    imwrite(watermark_2_extracted,strcat(TapCover(i).name,'\w1w2\W2_',src(j).name,'.png'));
    catch
    disp('An error occurred while retrieving information from the internet.');
    disp('Execution will continue.');
    end
    end
end