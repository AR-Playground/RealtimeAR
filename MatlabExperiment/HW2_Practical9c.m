function r=HW2_Practical9c( templateMetaFileName, numFrames, imgHeight, imgWidth, Imgs )

%2015.2.26
%Mincong: load from outside to prevent duplicated loading
%LoadVideoFrames

load( templateMetaFileName );
%load minX minY patchOffset pixelsTemplate pos


numParticles = 100;

if( templateMetaFileName == 'll' )
r = processCondensationFilter( templateMetaFileName, numFrames, imgHeight, imgWidth, Imgs, ...
                        numParticles, llminX, llminY, llpatchOffset, llpixelsTemplate, llpos );
end

if( templateMetaFileName == 'lr' )
r = processCondensationFilter( templateMetaFileName, numFrames, imgHeight, imgWidth, Imgs, ...
                        numParticles, lrminX, lrminY, lrpatchOffset, lrpixelsTemplate, lrpos );
end

if( templateMetaFileName == 'ul' )
r = processCondensationFilter( templateMetaFileName, numFrames, imgHeight, imgWidth, Imgs, ...
                        numParticles, ulminX, ulminY, ulpatchOffset, ulpixelsTemplate, ulpos );
end

if( templateMetaFileName == 'ur' )
r = processCondensationFilter( templateMetaFileName, numFrames, imgHeight, imgWidth, Imgs, ...
                        numParticles, urminX, urminY, urpatchOffset, urpixelsTemplate, urpos );
end

end
