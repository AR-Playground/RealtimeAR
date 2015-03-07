function result = normalizeToX(result,X)

localmax = max(result(:,1));
localmin = min(result(:,1));

%width
half_length = (localmax - localmin)/2;
%get local center
local_center = localmax - half_length;
%move to center
result(:,1) = result(:,1) - local_center;
%normalize
result(:,1) = result(:,1)/half_length*X;

end