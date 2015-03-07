function out = preprocessModel( out )

out(:,1) = normalizeToX(out(:,1),50);
out(:,2) = normalizeToX(out(:,2),50);
zmax = max(out(:,3));
zmin = min(out(:,3));
length = zmax-zmin; 
out(:,3) = (out(:,3) - zmax) / length * 100;

out = out';

end

