function [N]= NC(original,reconstructed)

Mc= size(original,1);
Nc= size(original,2);
sum1 = 0;
sum2 = 0;
sum3 = 0;

for (i=1:Mc)
for(j=1:Nc)

sum1 = sum1 + (original(i,j)*reconstructed(i,j));
sum2 = sum2 + (original(i,j)*original(i,j));
sum3 = sum3 + (reconstructed(i,j)*reconstructed(i,j));

end
end

sqsum2= sqrt(sum2);
sqsum3= sqrt(sum3);

N = (sum1)/(sqsum2*sqsum3);

end