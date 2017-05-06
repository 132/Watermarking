function y = ROI(cover)
imshow(cover);
h = impoly;
wait(h);
y = createMask(h);
end