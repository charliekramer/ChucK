// parallel vs series echoes

//synch
.05 => float gainSet;

59 => float midiBase;

60./80./2 => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

8 => float beatDiv; // beat division

//0 => int parallel; 
//for some reason this doesn't work--fix later

//if (false) {
//   Blit b => Envelope env => Echo e => Echo e2 => Echo e3 => dac;
//  <<< "Here par != 1" >>>;
//}
//else {
//   <<< "Here par == 1" >>>;
    Blit b => Envelope env => Echo e =>  dac;
    b => Envelope env2 => Echo e2 => PitShift pit2 =>  Pan2 p2 => dac;
    b => Envelope env3 => Echo e3 => PitShift pit3 => Pan2 p3 => dac;
//}
 
SinOsc LFO1 => blackhole; // control echo mix parameters
SinOsc LFO2 => blackhole;
SinOsc LFO3 => blackhole;

.1/beattime => LFO1.freq;
.13/beattime => LFO2.freq;
.17/beattime => LFO3.freq;

1 => pit2.mix;
1 => pit3.mix;

Std.mtof(midiBase+4)/Std.mtof(midiBase) => pit2.shift;
Std.mtof(midiBase+7)/Std.mtof(midiBase) => pit3.shift;


gainSet => b.gain;
    
//echo parameters
/*
5::second => e.max;
1.75::second => e.delay;
.5::second => e2.delay;
.125::second => e3.delay;
*/

5::second => e.max => e2.max => e3.max;
1.75*beat => e.delay;
.25*beat => e2.delay;
1.35*beat => e3.delay;


0.5 => e.mix;
0.5 => e2.mix;
0.5 => e3.mix;

.5 => e.gain;
.5 => e2.gain;
.5 => e3.gain;

e => e;
e2 => e2;
e3 => e3;

//e => e3 => e2;
//e3 => e2 => e;


// pan paramters

-1.0 => p2.pan;
1.0 => p3.pan;


// blit frequency

Std.mtof(midiBase) => b.freq;

//set up harmonics cycle; start point and diff over cycle
2 => int harm; 
1 => int harmdiff;

//loop thru harmonics

while (true) {
	harm => b.harmonics;
	1 => env.keyOn;
	beat/beatDiv => now;
	1 => env.keyOff;
	beat/beatDiv => now;
	
	harm => b.harmonics;
	1 => env2.keyOn;
	beat/beatDiv => now;
	1 => env2.keyOff;
	beat/beatDiv => now;
	
	harm => b.harmonics;
	1 => env3.keyOn;
	beat/beatDiv => now;
	1 => env3.keyOff;
	beat/beatDiv => now;
	
	harmdiff+harm=>harm;
	if (harm > 20 || harm == 2) -1*=>harmdiff;
	
	Math.fabs(LFO1.last()) => e.mix;
	Math.fabs(LFO2.last()) => e2.mix;
	Math.fabs(LFO3.last()) => e3.mix;
}
// old loop
while (true) {
    harm => b.harmonics;
    1 => env.keyOn;
    beat/beatDiv => now;
    1 => env.keyOff;
    beat/beatDiv => now;
    harmdiff+harm=>harm;
    if (harm > 20 || harm == 2) -1*=>harmdiff;
	Math.fabs(LFO1.last()) => e.mix;
	Math.fabs(LFO2.last()) => e2.mix;
	Math.fabs(LFO3.last()) => e3.mix;
}