.05 => float gainSet;

4 => int n;

ModalBar bell[n];
Echo echo[n];
NRev rev[n];

58+12 => float baseFreq;

[0.,2., 7.,9.] @=> float notes[];

60./80.*.125 => float beatSec;
beatSec::second => dur beat;

for (0 => int i; i<bell.size(); i++) {
	bell[i] => echo[i] => rev[i] => dac;
	5*beat => echo[i].max;
	(i+1)*.75*beat => echo[i].delay;
	.3 => echo[i].mix;
	.5 => echo[i].gain;
	echo[i] => echo[i];
	.4 => rev[i].mix;
	1 => bell[i].preset; // preset 1 is loud
	gainSet => bell[i].gain;
}


while (true) {
	for (0 => int i; i<bell.size(); i++) {
		Std.mtof( baseFreq + notes[Std.rand2(0,notes.size()-1)] + 12*Std.rand2(0,2) ) => bell[i].freq;
		1 => bell[i].noteOn;
	}
	beat => now;
}
