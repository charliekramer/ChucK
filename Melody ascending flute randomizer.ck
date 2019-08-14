Flute flute => Chorus chorus => Echo echo => NRev rev => dac;

.1 => float gainSet;

gainSet => flute.gain;

60./80. => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

.1 => chorus.modFreq;
.9 => chorus.mix;

beat*5 => echo.max;
beat*1.25 => echo.delay;
.5 => echo.mix;
.5 => echo.gain;
echo => echo;

1 => int echoRand;

.2 => rev.mix;

59 => float midiBase;

float beatFrac;

[0.,4.,5.,6.,7.,9.,10.,11.,12.] @=> float notes[];

now + 60::second => time future;

1. => float cutoff;

while (now < future) {
	
	
	for (0 => int i; i < notes.cap(); i++) {
		
		Std.mtof(midiBase + notes[i]) => flute.freq;
		if (Std.rand2f(0.,1.) > cutoff ) {
			<<< "random" >>>;
			Std.mtof(midiBase + notes[Std.rand2(0,notes.cap()-1)]) => flute.freq;
			if (Std.rand2f(0.,1.) > cutoff) flute.freq()/2. => flute.freq;
			else if (Std.rand2f(0.,1.) > cutoff) flute.freq()*2. => flute.freq;
		}
		
		if (echoRand == 1) {
			if (Std.rand2f(0.,1.) > cutoff) {
				Std.rand2f(.1,2.25)*beat => echo.delay;
				<<< "rand echo" >>>; 
			}
		}
			
		
		1 => flute.noteOn;
		Std.rand2f(.25,1.75) => beatFrac;
		beatFrac*beat => now;
		
		1 => flute.noteOff;
		(2.-beatFrac)*beat => now;
	}
	
	Std.rand2f(0.,1.) => cutoff;
	<<< "cutoff", cutoff>>>;
	
}

<<< " ending ascending flute randomizer" >>>;
8*beat => now;
