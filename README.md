# RealtimeAR

### 2015.8.9 Try to make a AR game
Local:  http://localhost/src/

reference:    
AR snake: http://www.hexahedria.com/2014/11/18/a-tale-of-two-hackathons-part-2-augmented-reality-snake/　　
Run localhost:　http://segmentfault.com/q/1010000003018927　　


###2015.3.1 Semi-Realtime AR in Matlab

<img src="https://github.com/mincongzhang/MachineVision/raw/master/augmented_reality.jpg" alt="augmented_reality" title="augmented_reality" width="500"/>


Problems:  
(1) Prediction lags for the edges occur when camera shakes.   
(Improve the Condensation filter algorithm)  

(2) 4 edges' predictions are now independent to each other.   
(May use their correlations to improve.)  

(3) Sometimes virtual cube may have sudden variations, problem unknown.   
(But it seems is not COndensation filter's problem, maybe problems in estimatePlanePose())  
(Also cube will not have big change in volume, which can be used for optimization)  

(4) Need speed up. (More optimization is needed, and can speed up when written in Java or C++ and use multithreading)  
