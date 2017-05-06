function y = exROI(ROI,level)
d = level; % the dimension of the sub matrix
[x,y] = size(ROI);

% perform integer division by three
m = floor(x/d);
n = floor(y/d);

% find out how many cols and rows have to be left out
m_rest = mod(x,d);
n_rest = mod(y,d);

% remove the rows and columns that won't fit
new_ROI = ROI(1:(end-m_rest), 1:(end-n_rest));

%  this steps you won't have to perform if you use mat2cell
% creates the matrix with (m,n) pages 
new_ROI = reshape( new_ROI, [ d m d n ] );
new_ROI = permute( new_ROI, [ 1 3 2 4 ] );



MatrixRC=[];
Matrix=ones(x/level,y/level);
for row = 1:x/level
    for col = 1:y/level
        temp = new_ROI(:,:,row,col); %gán biesn t?m
        count= sum(temp(:)); % tinh tong so 1
        if count >= (level^2/2)  %so sánh t?ng s? 1 trong m?ng v?i t?ng s? pixel gom l?i ví d? 2x2 mà count(2)>2 thì vùng ?ó thu?c ROI 4x4 thì 8 8x8 thì 32
           Matrix(row,col)=132.2311;
            % MatrixRC=[MatrixRC;[row col]];
        end
    end
end

%{
%for row = 1:x/level
    for col = 1:y/level
        col
        temp = new_ROI(:,:,1,col)% gan bien
        count= sum(temp(:)) %tinh tong so 1 trong mang
        if count>=(level^2/2)  %so sánh t?ng s? 1 trong m?ng v?i t?ng s? pixel gom l?i ví d? 2x2 mà count(2)>2 thì vùng ?ó thu?c ROI 4x4 thì 8 8x8 thì 32
            new_ROI(:,:,1,col)=132.2311*ones(level,level);
            MatrixRC=[MatrixRC;[1 col]];
            
        end
    end
%end
%}
y = Matrix;
end
