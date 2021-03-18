# FusorSim
HTML5 simulator/game that tracks ions in IEC fusion device.

Try it out at https://fusionresearch.github.io/FusorSim/


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
or
npx browser-sync start -s -f . --no-notify --host 127.0.0.1 --port 5000
```

You should now be able to test the sim at  http://localhost:5000




## Modeling constraints
for a 1 cubic meter chamber,  with D pressure of y 1.2E-5 Torr that is 1.8E20 particles, too many to simualte

1.2E-5 * 1/760 * 1000*22.4 = 0.0003 mol Detrium = 1.8E20 particles/cubic meter

At 1E-3 torr 2.7 x 10E19 / 760 x 1E3 = 3.6 x E13 molecules/cm3 

1 × 10−7 Torr, corresponds to a neutral particle density of ≈ 3.2 × 10^15 m−3  


