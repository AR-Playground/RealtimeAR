function [weight_of_samples,samples_to_propagate,particles_old,result] ... 
         = CondensationFilter ...
         (  imgHeight, imgWidth, Imgs,...
           numParticles, minX, minY, patchOffset, pixelsTemplate, pos,...
           weight_of_samples,samples_to_propagate,numDims_w,particles_old,iFrame,...
           result)

  
    % TO DO: compute the cumulative sume of the weights. You could refer to
    % the MATLAB builtin function 'cumsum'.
    cum_hist_of_weights = cumsum(weight_of_samples);


    % ==============================================================
    % Resample the old distribution at time t-1 and select samples favoring
    % those with a higher posterior probability.
    % ==============================================================
    samples_to_propagate = zeros(numParticles,1);

    % Pick random thresholds (numParticles X 1 matrix) in the cumulative
    % probability's range [0,1]:
    some_threshes = rand(numParticles,1);


    % For each random threshold, find which sample in the ordered set is
    % the first one to push the cumulative probability above that
    % threshold, e.g. if the cumulative histogram goes from 0.23 to 0.26
    % between the 17th and 18th samples in the old distribution, and the
    % threshold is 0.234, then we'll want to propagate the 18th sample's w
    % (i.e. particle #18).
    
    for sampNum = 1:numParticles
        thresh = some_threshes(sampNum);
        for index = 1:numParticles
            if( cum_hist_of_weights(index) > thresh )
                break;
            end;
        end;
        samples_to_propagate(sampNum) = index;
    end;
    % Note: it is fine even if some of the old particles get picked repeatedly, while
    % others don't get picked at all.


    % Predict where the particles we plucked from the old distribution of 
    % state-space will go in the next time-step. This means we have to apply 
    % the motion model to each old sample.

    particles_new = zeros( size(particles_old) );
    for particleNum = 1:numParticles

        % TO DO: Incorporate some noise, e.g. Gaussian noise with std 10,
        % into the current location (particles_old), to give a Brownian
        % motion model.
        noise = normrnd(0,10,[1,size(particles_old,2)]);
        particles_new(particleNum,:) = particles_old( samples_to_propagate(particleNum),: ) + noise;
        particles_new(particleNum,:) = round(  particles_new(particleNum,:)  ); % Round the particles_new to simplify Likelihood evaluation.
    end;
    
    % TO DO (optional): change the motion model above to have different 
    % degrees of freedom, and optionally completely different motion models.
    % See Extra Credit for more instructions.

    Im2 = double( Imgs{iFrame} );
    
    % From here we incorporate the measurement for the new state (time t):
    % The new particles at predicted locations in state-space
    % for time t, are missing their weights: how well does each particle
    % explain its observation x_t? 
    for particleNum = 1:numParticles

        % Convert the particle from state-space w to measurement-space x:
        % Note: Trivial here because both are in 2D space of image
        % coordinates

        % Within the loop, we evaluate the likelihood of each particle:
        particle = particles_new(particleNum,:);
        % Check that the predicted location is a place we can really evaluate
        % the likelihood.
        s = size(pixelsTemplate);
        inFrame = particle(1) >= 1.0   &&  particle(1)+ s(1) <= imgHeight && ...
                particle(2) >= 1.0   &&  particle(2) + s(2) <= imgWidth;
        if( inFrame )
            minX = particles_new(particleNum,2);
            minY = particles_new(particleNum,1);
            
            % A stand-alone demo (ExhaustiveTemplateSearchDemo.m) is
            % provided to illustrate the functionality of our likelihood
            % function:
            % MeasurePatchSimilarityHere(im,template,x,y)
            % im : image to search
            % template : the given template
            % x, y : the upper left corner in the image to place the
            % template for similarity evaluation
            weight_of_samples(particleNum) = ...
                MeasurePatchSimilarityHere( Im2, pixelsTemplate, minY, minX );
        else
            weight_of_samples(particleNum) = 0.0;
        end;

    end;

    % TO DO: normalize the weights 
    weight_of_samples = weight_of_samples./(sum(weight_of_samples));

    % TO DO: Compute the coordinate of the "best" (i.e. MAP) location by
    % computing the weighted average of all the particles:
    weightedAve = weight_of_samples'*particles_new;
    
    middleOfTrackedPatch = weightedAve + patchOffset;
    result(iFrame,:) = middleOfTrackedPatch; % Return the MAP of middle position 
    % of a patch. That 'middle' is the patch's interest point in the
    % current frame. The coordinate we've been using everywhere is the
    % upper-left corner of each patch. We're actually most interested
    % in the corner of the square. In this case, a patchOffset that goes 
    % along with each pixelsTemplate, is given to reset the interest point
    % back to the middle of the patch.
    
%     set(0,'CurrentFigure',hImg)
%     imagesc(Im2/255)
%     colormap(gray);
%     set(gcf,'Position',[23 125 640 480]);
%     set(gcf,'Color',[1 1 1]);
%     title(sprintf( 'Particles projected to measurement-space\n(Time %d)', iTime));
%     hold on
%     plot(particles_new(:,2), particles_new(:,1), 'rx')
%     plot(middleOfTrackedPatch(2), middleOfTrackedPatch(1), 'bo')
%     hold off
%     drawnow

    % Optional code to save out figure:
%     pngFileName = sprintf( '%s_%.5d.png', 'myOutput(1point)', iTime );
%     saveas(gcf, pngFileName, 'png');
%     print( gcf, '-dpng', '-r80', pngFileName ); % Gives 640x480 (small) figure


    % Now we're done updating the state for time t. 
    % For Condensation, just clean up and prepare for the next round of 
    % predictions and measurements:
    particles_old = particles_new;
    clear particles_new;

end

