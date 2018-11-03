// parallel vs series echoes with harmonic content cycling

//time synch

60./94. => float beatSec;

beatSec::second => dur beat;

beat - (now % beat) => now;

//SERIES
//  Blit b => Envelope env => Echo e => Echo e2 => Echo e3 => Gain g => dac;

//PARALLEL 

Blit b => Envelope env => Echo e =>  Gain g1 => dac; 
b => env => Echo e2 => Pan2 p2 => Gain g2 => dac.left; 
b => env => Echo e3 => Pan2 p3 => Gain g3 => dac.right; 
// Paralle--pan and gain paramters
-1.0 => p3.pan;
1.0 => p3.pan;
0.01 => g1.gain => g2.gain => g3.gain;
0.09 => g2.gain => g3.gain;



    
//echo parameters
5::second => e.max;
beat*1.5 => e.delay;
beat*.75 => e2.delay;
beat/2. => e3.delay;

0.7 => e.mix;
0.7 => e2.mix;
0.7 => e3.mix;



// blit frequency

Std.mtof(58-12) => b.freq;
.5=>b.gain;

//set up harmonics cycle; start point and diff over cycle
5=> int harm; 
-1=>int harmdiff;

//loop thru harmonics

while (true) {
    harm => b.harmonics;
    1 => env.keyOn;
    beat/2 => now;
    1 => env.keyOff;
    beat/2 => now;
    harmdiff+harm=>harm;
    if (harm > 20 || harm == 2) -1*=>harmdiff;
}