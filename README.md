# FusorSim
HTML5 simulator/game that tracks ions in IEC fusion device.


Dev goals order of importance:
* Written in Javascript for low barrier to entry for development(may change if perf requires)
* Simulate [Fenley Fusor](http://www.ddprofusion.com/) first, perhaps other designs later.
* 3d Visualization to understand the working principle of the fusor.
* Controls to adjust fusor params,  E-field, B-field, deuterium pressure, etc.
* Gauges and strip chart to measure device performance.
* Run sim on gpu if possible
* Physical accuracy, this will be the most difficult. 


Written in HTML5 and js using canvas, d3.js, matter.js, [three.js](https://threejs.org/)


## Dev Quick Start
Make sure you have npm, you can get it from https://nodejs.org/en/download/
 
``` bash
#checkout the project
git clone https://github.com/FusionResearch/FusorSim.git  

#start a localhost server, assuming you have node/npm
npx serve
```

You should now be able to test the sim at  http://localhost:5000