Flute flute => PoleZero f => Echo echo => NRev rev => Pan2 pan => dac;
flute => f => Echo echo2 => NRev rev2 => Pan2 pan2 => dac;

.99 => f.blockZero; // closer to 1 less grindy

.1 => flute.gain;

.2 => rev.mix => rev2.mix;

SinOsc LFO => blackhole; // drives jetDelay

60./94. => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

3.5 => float beat1; // length of first beat; second = beatMeasure - beat1; 
                   // 0.5,1.5, 3.5
4.0 => float beatMeasure; // total number of beats (on plus off) 4 or 8

if (beatMeasure < beat1 ) <<< "error beatMeasure < beat1">>>;

-1 => pan.pan;
1 => pan2.pan;

.2 => flute.noiseGain;
.3 => flute.jetDelay; // produces nice overtones for high values;
.6 => flute.jetReflection; // produces ringing overtone for high value
.3 => flute.endReflection; // produces ringing overtone for high value
.5 => flute.rate;

8*beat => echo.max => echo2.max;
1.5*beat => echo.delay;
.6*beat => echo2.delay;
.4 => echo.gain => echo2.gain;
.5 => echo.mix => echo2.mix;
echo => echo2 => echo;
echo2 => echo => echo2;

55 -12 -12 => float midiBase;

Std.mtof(midiBase) => flute.freq; //90, 59

1.0/beatSec*.25*.125*.1 => LFO.freq;
1.0 => LFO.gain;

now + 120*beat => time future;

while (now < future) {
	
	1 => flute.noteOn;
	beat1*beat => now;
	
	1 => flute.noteOff;
	(beatMeasure-beat1)*beat => now;
	
    (LFO.last()+1)*.5 => flute.jetDelay;
	
//	 <<< flute.jetDelay() >>>;
	
}

10::second => now;