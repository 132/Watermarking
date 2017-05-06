%% Watermark Embedding algorithm
function [watermarked_image] = watermark_embedding(cover, w1, w2)

% 1. convert w1,w2 to double and create RoiMap
try     % co loi trong try thi lam` catch neu ko loi thi ra ngoai
    getQR();
catch 
    w1 = encode_qr(w1, 'Character_set', 'ISO-8859-1');
end

QRw1 = double(w1);
QRw2 = double(w2);
RoiMap = ROI(cover);
% create exROI
R2 = exROI(RoiMap,4);
R1 = exROI(RoiMap,2);

% 2. Apply Haar wavelet and decompose cover image into four sub-bands:
[LL_1, HL_1, LH_1, HH_1] = dwt2(cover, 'haar');

% 3. Using Haar wavelet, further decompose LL band to the 4th level.
[LL_2, HL_2, LH_2, HH_2] = dwt2(LL_1, 'haar');    % 1st step DWT

% 4. Apply SVD to HH (high frequency) band
[Uh1 Sh1 Vh1] = svd(HH_1, 'econ'); % W1
[Uh2 Sh2 Vh2] = svd(HH_2, 'econ'); % W2

% 5. Watermark logo W is decomposed using SVD
[Uw1 Sw1 Vw1] = svd(QRw1, 'econ');
[Uw2 Sw2 Vw2] = svd(QRw2, 'econ');

% 6. Replace singular values of the HH (high frequency) band with the
% singular values of the watermark
Sh_diag_1 = diag(Sh1);
Sw_diag_1 = diag(Sw1);

Sh_diag_2 = diag(Sh2);
Sw_diag_2 = diag(Sw2);

% Embedded algorithm
key1 = [];
for i = 1:length(Sw_diag_1)
    for j = 1:length(Sh_diag_1)
        if R1(j,j) == 132.2311
           temp(j) = 255;
           continue
        end
        temp(j) = abs(Sw_diag_1(i) - Sh_diag_1(j));
    end
    [value1 index1] = min(temp);
    key1(i) = index1;
    Sh_diag_1(index1) = Sw_diag_1(i);
end
Sh1(logical(eye(size(Sh1)))) = Sh_diag_1;

key2 = [];
for i = 1:length(Sw_diag_2)
    for j = 1:length(Sh_diag_2)
        if R2(j,j) == 132.2311
           temp2(j) = 255;
           continue
        end
        temp2(j) = abs(Sw_diag_2(i) - Sh_diag_2(j));
    end
    [value1 index1] = min(temp2);
    key2(i) = index1;
    Sh_diag_2(index1) = Sw_diag_2(i);
end
Sh2(logical(eye(size(Sh2)))) = Sh_diag_2;

% 7. Apply SVD to obtain the modified HH band wich now holds the SV's of
% watermark logo
HH_1_modified =  Uh1 * Sh1 * Vh1';
HH_2_modified =  Uh2 * Sh2 * Vh2';

% 8. Apply inverse DWT with modified LL(LL_inv) & HH(HH_modified) band to
% obtain the watermarked image
% Here the HH band should be the one modified with SV's
LL_1_di = idwt2(LL_2, HL_2, LH_2, HH_2_modified, 'haar');
watermarked_image = idwt2(LL_1_di, HL_1, LH_1, HH_1_modified, 'haar');

% 10. Crete KEY1 and KEY2
Skey1 = Sw1;
Skey1(logical(eye(size(Skey1)))) = key1';
KEY1 = Uw1 * Skey1 * Vw1';

Skey2 = Sw2;
Skey2(logical(eye(size(Skey2)))) = key2';
KEY2 = Uw2 * Skey2 * Vw2';

% 11. Save KEY1 and KEY2
save KEY1.mat KEY1
save KEY2.mat KEY2
end