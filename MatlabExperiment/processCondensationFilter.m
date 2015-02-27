function r = processCondensationFilter( templateMetaFileName, numFrames, imgHeight, imgWidth, Imgs,...
                                 numParticles, minX, minY, patchOffset, pixelsTemplate, pos )

weight_of_samples = ones(numParticles,1);

% TO DO: normalize the weights (may be trivial this time)
weight_of_samples = weight_of_samples./sum(weight_of_samples);

% Initialize which samples from "last time" we want to propagate: all of
% them!:
samples_to_propagate = [1:numParticles]';


% ============================
% NOT A TO DO: You don't need to change the code below, but eventually you may
% want to vary the number of Dims.
numDims_w = 2;

% NOT A TO DO: You don't need to change anything here but please make sure you
% MATLAB console to find more info for the buildin function. 
%
% Here we randomly initialize some particles throughout the space of w.
% The positions of such particles are quite close to the know initial
% position:
particles_old = repmat([minY minX], numParticles, 1 ) + 5*rand( numParticles, numDims_w );
% ============================


hImg = figure;
hSamps = figure;

% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% Was our "Loop from here" point in Part a.

% Initialize a temporary array r to store the per-frame MAP estimate of
% w. This is what we'll return in the end.
r = zeros(numFrames, numDims_w);

for( iTime = 1:numFrames )
    
   [weight_of_samples,samples_to_propagate,numDims_w,particles_old,r] ... 
         = CondensationFilter ...
         ( templateMetaFileName, numFrames, imgHeight, imgWidth, Imgs,...
           numParticles, minX, minY, patchOffset, pixelsTemplate, pos,...
           weight_of_samples,samples_to_propagate,numDims_w,particles_old,hImg,hSamps,iTime,...
           r);

end % End of for loop over each frame in the sequence

end

