function test= crop(cover,tyle)
I = cover;
[dai rong] = size(cover);
T = (dai - dai/sqrt(tyle))/2;
T
    for i=1:dai
        for j=1:rong
            if (i<=T || j<=T || i >=(dai-T) || j >=(rong-T))
                I(i,j)=0;
            end
        end
    end
 test = I;   
end