function r = processCondensationFilter( numFrames, imgHeight, imgWidth, Imgs,...
                                  minX, minY, patchOffset, pixelsTemplate, pos )

numParticles=100;
numDims_w = 2;
weight_of_samples = ones(numParticles,1);
weight_of_samples = weight_of_samples./sum(weight_of_samples);
samples_to_propagate = [1:numParticles]';
particles_old = repmat([minY minX], numParticles, 1 ) + 5*rand( numParticles, numDims_w );

r = zeros(numFrames, numDims_w);

for iFrame = 1:numFrames
   [weight_of_samples,samples_to_propagate,particles_old,r] ... 
         = CondensationFilter ...
         ( imgHeight, imgWidth, Imgs,...
           numParticles, minX, minY, patchOffset, pixelsTemplate, pos,...
           weight_of_samples,samples_to_propagate,numDims_w,particles_old,iFrame,...
           r);
end


end

