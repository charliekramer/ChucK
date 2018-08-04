// parallel vs series echoes with harmonic content cycling

//time synch

500::ms - (now % 500::ms) => now;

//SERIES
//  Blit b => Envelope env => Echo e => Echo e2 => Echo e3 => Gain g => dac;

//PARALLEL 

Blit b => Envelope env => Echo e =>  Gain g1 => dac; 
b => env => Echo e2 => Pan2 p2 => Gain g2 => dac; 
b => env => Echo e3 => Pan2 p3 => Gain g3 => dac; 
// Paralle--pan and gain paramters
-1.0 => p3.pan;
1.0 => p3.pan;
0.01 => g1.gain => g2.gain => g3.gain;
0.09 => g2.gain => g3.gain;



    
//echo parameters
5::second => e.max;
.75::second => e.delay;
.5::second/4 => e2.delay;
.25::second => e3.delay;

0.2 => e.mix;
0.7 => e2.mix;
0.7 => e3.mix;



// blit frequency

110 => b.freq;
.5=>b.gain;

//set up harmonics cycle; start point and diff over cycle
5=> int harm; 
-1=>int harmdiff;

//loop thru harmonics

while (true) {
    harm => b.harmonics;
    1 => env.keyOn;
    .25::second => now;
    1 => env.keyOff;
    .25::second => now;
    harmdiff+harm=>harm;
    if (harm > 20 || harm == 2) -1*=>harmdiff;
}