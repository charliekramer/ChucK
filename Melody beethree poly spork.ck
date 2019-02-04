
// make an array of ugens and call by [i], iterate i in loop


120./60.*.5 => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

60 => float midiBase;
//[0,3,7,3,7,10,7,10,14,10,14,17] @=> int notes[];
//[1,1,2,1,1,2,1,1,2,1,1,2] @=> int beats[];

[0,3,7,3,7,10] @=> int notes[];
[1,1,2,1,1,2] @=> int beats[];


0 => int i;

while (true) {
	
	
	spork~play(midiBase+notes[i]);
    spork~play(midiBase+notes[i]-12);
	
	beats[i]*beat => now;

	i++;
	if (i > notes.cap()-1) 0 => i;
	
}

fun void play (float note) {
	
	BeeThree bar => HPF filt => NRev rev => Gain g => dac;
	
	.05 => g.gain;
	
	.2 => rev.mix;
	
	5 => filt.Q;
	
	Std.mtof(note) => bar.freq => filt.freq;
	
	1 => bar.noteOn;
	
	4*beat => now;
}