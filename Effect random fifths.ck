//random jumps in fifths (1.5^n)

Saxofony sax => NRev rev => Pan2 panS => dac;
Clarinet clarinet => NRev rev2 => Pan2 panC => dac;

.1 => float gainSet;

.75 => panS.pan;
-1*panS.pan() => panC.pan;

.2 => rev.mix => rev2.mix;

gainSet => sax.gain;
gainSet => clarinet.gain;

60./80. => float beatSec;
beatSec::second => dur beat;

now + 120::second => time future;

beat - (now % beat) => now;

59-12 => float midiBase; // try +7, +5
Std.mtof(midiBase) => sax.freq;
Std.mtof(midiBase+7) => clarinet.freq;

sax.freq()*3 => float maxFreq;
sax.freq()/3 => float minFreq;
float beatFraction, beatPause;

while (now < future) {
	
	sax.freq()*Math.pow(1.5,Std.rand2(-1,1)) => sax.freq;
	sax.freq()*Math.pow(1.5,Std.rand2(-1,1)) => clarinet.freq;
	if (sax.freq() > maxFreq || sax.freq() < minFreq) {
		Std.mtof(midiBase) => sax.freq;
		Std.mtof(midiBase+7) => clarinet.freq;
	}
	Std.rand2f(0,1.5) => beatFraction;	
	Std.rand2f(0,1.5) => beatPause;
	<<< "beatFraction, beatPause", beatFraction, beatPause>>>;
	1 => sax.noteOn;
	beat*beatFraction => now;
	1 => clarinet.noteOn;
	beat*(8 - beatPause - beatFraction) => now;
	1 => sax.noteOff;
	1 => clarinet.noteOff;
	beat*beatPause => now;
}

5::second => now;
	
	
