# RealtimeAR

###Try AR bad apple
Local:  http://localhost/src/

##### reference:    
AR snake:     
http://www.hexahedria.com/2014/11/18/a-tale-of-two-hackathons-part-2-augmented-reality-snake/　　  
https://github.com/khanh111/ARS    
Run localhost:　  
http://segmentfault.com/q/1010000003018927　　


###Semi-Realtime AR algorithm in Matlab

<img src="https://github.com/mincongzhang/MachineVision/raw/master/augmented_reality.jpg" alt="augmented_reality" title="augmented_reality" width="500"/>


Problems:  
(1) Prediction lags for the edges occur when camera shakes.   
(Improve the Condensation filter algorithm)
(Someone told me SIFT will be much better)

(2) 4 edges' predictions are now independent to each other.   
(May use their correlations to improve.)  

(3) Sometimes virtual cube may have sudden variations, problem unknown.   
(But it seems is not COndensation filter's problem, maybe problems in estimatePlanePose())  
(Also cube will not have big change in volume, which can be used for optimization)  

(4) Need speed up. (More optimization is needed, and can speed up when written in Java or C++ and use multithreading)  
