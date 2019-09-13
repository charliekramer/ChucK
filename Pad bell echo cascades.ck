.1 => float gainSet;

4 => int n;

45::second => dur length;

ModalBar bell[n];
Echo echo[n];
NRev rev[n];
Dyno dyn[n];
Pan2 pan[n];

58 => float baseFreq;

[0.,2., 7.,9.] @=> float notes[];

60./80.*.125*2*2*2*2 => float beatSec; // take out 8*2 to get textured sound
beatSec::second => dur beat;

for (0 => int i; i<bell.size(); i++) {
	bell[i] => echo[i] => rev[i] => dyn[i] => pan[i] => dac;
	5*beat => echo[i].max;
	(i+1)*.75*beat => echo[i].delay;
	.3 => echo[i].mix;
	.5 => echo[i].gain;
	echo[i] => echo[i];
	.4 => rev[i].mix;
	1 => bell[i].preset; // preset 1 is loud
	gainSet => bell[i].gain;
	-1. + 2.*i/(n-1) => pan[i].pan;
	<<< "pan ", i, pan[i].pan() >>>;
}


now + length => time future;

while (now < future) {
	for (0 => int i; i<bell.size(); i++) {
		Std.mtof( baseFreq + notes[Std.rand2(0,notes.size()-1)] + 12*Std.rand2(0,2) ) => bell[i].freq;
		Std.rand2f(.1,1) => bell[i].noteOn;
	}
	beat => now;
}

15::second => now;
