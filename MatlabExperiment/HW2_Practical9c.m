function r=HW2_Practical9c( templateMetaFileName, numFrames, imgHeight, imgWidth, Imgs )

%2015.2.26
%Mincong: load from outside to prevent duplicated loading
%LoadVideoFrames

load( templateMetaFileName );
%load minX minY patchOffset pixelsTemplate pos


numParticles = 100;

if( templateMetaFileName == 'll' )
r = processCondensationFilter( numFrames, imgHeight, imgWidth, Imgs, ...
                        llminX, llminY, llpatchOffset, llpixelsTemplate, llpos );
end

if( templateMetaFileName == 'lr' )
r = processCondensationFilter( numFrames, imgHeight, imgWidth, Imgs, ...
                        lrminX, lrminY, lrpatchOffset, lrpixelsTemplate, lrpos );
end

if( templateMetaFileName == 'ul' )
r = processCondensationFilter( numFrames, imgHeight, imgWidth, Imgs, ...
                        ulminX, ulminY, ulpatchOffset, ulpixelsTemplate, ulpos );
end

if( templateMetaFileName == 'ur' )
r = processCondensationFilter( numFrames, imgHeight, imgWidth, Imgs, ...
                        urminX, urminY, urpatchOffset, urpixelsTemplate, urpos );
end

end
