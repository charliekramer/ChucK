// time limited weird flute model
// LFOs drive two parameters
// .5^x for beats
Flute flute  => ADSR env => NRev rev => Pan2 pan1 => dac;
env => Echo echo => Pan2 pan2 => dac;

SinOsc LFO1 => blackhole;
SinOsc LFO2 => blackhole;

.1 => float gainSet;

gainSet => flute.gain;

59+3*12 => float midiBase;

Std.mtof(midiBase) => flute.freq;

60./80*Math.pow(.5,0) => float beatSec; // set exponent to higher for chop fx
beatSec::second => dur beat;

30 => float length; //length of loop in seconds

1./beatSec*3.14 => LFO1.freq;
1./beatSec*2.71 => LFO2.freq;

.99 => flute.jetDelay;    
.88 => flute.jetReflection;    
.85 => flute.endReflection;
.32 => flute.noiseGain;
 6 => flute.vibratoFreq;
 .3 => flute.vibratoGain;
 .86 => flute.pressure;

0 => int jetDLFO; // use LFO for jetDelay;
0 => int jetRLFO; // use LFO for jetReflection;
1 => int envKeyOff;// key off envelope after noteOff

1 => LFO1.gain; //modifies jetDelay
1 => LFO2.gain; // modifies jetReflection

(beat, beat, .9, beat) => env.set;

10*beat => echo.max;
1.5*beat*.5 => echo.delay;
.5 => echo.gain;
1 => echo.mix;
echo => echo;

.1 => rev.mix;

.75 => pan1.pan;
pan1.pan()*-1 => pan2.pan;

beat - (now % beat) => now;

now + length::second => time future;

while (now < future) {
	
	1=> env.keyOn;
	1=> flute.noteOn;
	if (jetDLFO ==1 ) {
		
		Math.pow(LFO1.last()*LFO1.last(),.5) => flute.jetDelay;
		<<< "flute.jetDelay,", flute.jetDelay() >>>;
	}
	if (jetRLFO == 1) {
		
		Math.pow(LFO2.last()*LFO2.last(),.5) => flute.jetReflection;
		<<< "flute.jetReflection,", flute.jetReflection() >>>;
	}
	
	beat => now;
	1 => flute.noteOff;
	if (envKeyOff ==1 ) 1=>env.keyOff;
	beat*3 => now;
	
	
}
