%% Watermark extraction algorithm
function [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(watermarked_image) 

% Load KEY1 and KEY2
load KEY1.mat KEY1
load KEY2.mat KEY2

% 1. Using Haar wavelet, decompose the noisy watermarked image into four
% sub-bands: LL, HL, LH, and HH
[LLw_1 HLw_1 LHw_1 HHw_1] = dwt2(watermarked_image, 'haar');

% 2. Further decompose LL band to the 4th level.
[LLw_2, HLw_2, LHw_2, HHw_2] = dwt2(LLw_1, 'haar');    % 1st step DWT

% 3. Apply SVD to HH band
[Ucw1 Scw1 Vcw1] = svd(HHw_1, 'econ');
[Ucw2 Scw2 Vcw2] = svd(HHw_2, 'econ');

[Uw1 key1_dia Vw1] = svd(KEY1,'econ');
key1 = diag(key1_dia);
key1 = uint8(key1);

[Uw2 key2_dia Vw2] = svd(KEY2,'econ');

key2 = diag(key2_dia);
key2 = uint8(key2);

% 4. generte matrix HH band
HH_1_singularValues = zeros(length(Uw1));
Shh_1_diag = diag(HH_1_singularValues);
Scw_1_diag = diag(Scw1);

HH_2_singularValues = zeros(length(Uw2));
Shh_2_diag = diag(HH_2_singularValues);
Scw_2_diag = diag(Scw2);

% 5. Extract the singular values from HH band
for i = 1:length(key1)
    Shh_1_diag(i) = Scw_1_diag(key1(i));
end
HH_1_singularValues(logical(eye(size(HH_1_singularValues)))) = Shh_1_diag;

for i = 1:length(key2)
    Shh_2_diag(i) = Scw_2_diag(key2(i));
end
HH_2_singularValues(logical(eye(size(HH_2_singularValues)))) = Shh_2_diag;

% 6. Construct the watermark using singular values and orthogonal matrices
% Uw and Vw obtained using SVD of original watermark
watermark_1_extracted = Uw1 * HH_1_singularValues * Vw1';
watermark_2_extracted = Uw2 * HH_2_singularValues * Vw2';

%watermark_1_extracted = decode_qr(watermark_1_extracted);
end