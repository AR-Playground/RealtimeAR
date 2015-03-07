function out = testmodel()

out = ...
    [0.00472708 0.0012 -0.000833515
    0.0048 0.0012 0
    0 0 0
    0.00451052 0.0012 -0.0016417
    0.00415692 0.0012 -0.00240001 ];

out(:,1) = normalizeTo50(out(:,1));
out(:,2) = normalizeTo50(out(:,2));

zmax = max(out(:,3));
zmin = min(out(:,3));
length = zmax-zmin; 

out(:,3) = (out(:,3) - zmax) / length * 50;

out = out';
end
