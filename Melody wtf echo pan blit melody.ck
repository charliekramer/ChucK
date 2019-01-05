// parallel vs series echoes

//synch
60./120./2 => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;


//0 => int parallel; 
//for some reason this doesn't work--fix later

//if (false) {
//   Blit b => Envelope env => Echo e => Echo e2 => Echo e3 => dac;
//  <<< "Here par != 1" >>>;
//}
//else {
//   <<< "Here par == 1" >>>;
    Blit b => Envelope env => Echo e =>  dac;
    b => env => Echo e2 => Pan2 p2 => dac;
    b => env => Echo e3 => Pan2 p3 => dac;
//}
 

0.05 => b.gain;
    
//echo parameters
5::second => e.max;
1.75::second => e.delay;
.5::second => e2.delay;
.125::second => e3.delay;


0.2 => e.mix;
0.5 => e2.mix;
0.5 => e3.mix;

// pan paramters

-1.0 => p2.pan;
1.0 => p3.pan;


// blit frequency

Std.mtof(60+12) => b.freq;

//set up harmonics cycle; start point and diff over cycle
2=> int harm; 
2=>int harmdiff;

//loop thru harmonics

while (true) {
    harm => b.harmonics;
    1 => env.keyOn;
    beat/4 => now;
    1 => env.keyOff;
    beat/4 => now;
    harmdiff+harm=>harm;
    if (harm > 20 || harm == 2) -1*=>harmdiff;
}