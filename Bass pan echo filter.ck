// bass with panned echo and filter
3 => int n;// pretty normal for n =2 or 3, grindy above that (watch out, gets loud)

.001 => float gainSet;

SawOsc bass[n];
Pan2 panL;
Pan2 panR;
Echo echo;
ResonZ filter;
Envelope env1, env2;
Gain master;

gainSet/n => master.gain;

 -1 => panL.pan;
  1 => panR.pan;

55-36    => float midiBase; // watch out, will go nuts above 48 or so
.01 => float spread; // spread for frequencies

Std.mtof(midiBase) => filter.freq;
2 => filter.Q;
1 => float filtBase;
8 => int filterCycle; // multiply filter (1+ filtBase+ freq * j % filterCycle;
3. => float dampFactor; // divide into (1+filtBase + (j%filterCycle) to alleviate clicking from large chg in filter freq

for (0 => int i; i< bass.cap(); i++) {
	Std.mtof(midiBase)*(1+spread*(i-n/2)) => bass[i].freq;
	bass[i] => filter => master => env1 => panL => dac;
	bass[i] => filter => env2 => echo => master => panR => dac;

}

60./94. => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

//env1.set(beat*.25, .1::second, .1, .25*beat); // could use for ADSR
//env2.set(beat*.25, .1::second, .1, .25*beat); // I think it sounds better with Envelope

.1* beat => env1.duration;
.1* beat => env2.duration;

5*beat => echo.max;
beat*1.5 => echo.delay;
1 => echo.mix;
.5 => echo.gain;
echo => echo;

0 => int j;

now + 160::second => time future;

while (now < future) {
	
	j++;
	
	Math.min(Std.mtof( midiBase*(1+ filtBase + (j % filterCycle)/dampFactor)),5000) => filter.freq;
 
	1 => env1.keyOn;
	1 => env2.keyOff;
	2*beat => now;
	
	1 => env1.keyOff;
	1 => env2.keyOn;
	2*beat => now;
	
}
	