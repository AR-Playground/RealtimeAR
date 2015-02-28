function r = processCondensationFilter( numFrames, imgHeight, imgWidth, Imgs,...
                                  minX, minY, patchOffset, pixelsTemplate, pos )

numParticles=100;
weight_of_samples = ones(numParticles,1);

% normalize the weights (may be trivial this time)
weight_of_samples = weight_of_samples./sum(weight_of_samples);

% Initialize which samples from "last time" we want to propagate: 
samples_to_propagate = [1:numParticles]';

numDims_w = 2;


particles_old = repmat([minY minX], numParticles, 1 ) + 5*rand( numParticles, numDims_w );
% ============================

hImg = figure;

% Initialize a temporary array r to store the per-frame MAP estimate of
% w. This is what we'll return in the end.
r = zeros(numFrames, numDims_w);

for( iTime = 1:numFrames )
    
   [weight_of_samples,samples_to_propagate,numDims_w,particles_old,r] ... 
         = CondensationFilter ...
         ( imgHeight, imgWidth, Imgs,...
           numParticles, minX, minY, patchOffset, pixelsTemplate, pos,...
           weight_of_samples,samples_to_propagate,numDims_w,particles_old,hImg,iTime,...
           r);

end % End of for loop over each frame in the sequence

end

