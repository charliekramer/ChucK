
60 + 7-12 => float midiBase;

[0.,4.,12.,11.,0.,4.,12.,7.] @=> float notes[];
[0,-1,-1,0,1,2,3,-1,-1,-1,-1,-1,0,-1,-1,4,5,6,7,-1,-1,-1,-1,-1] @=> int select[];


StifKarp k => NRev rev => dac;
ModalBar bar => PRCRev rev2 => dac;

Std.mtof(midiBase-24) => bar.freq;

120./45./3*.5 => float beatSec;

beatSec::second => dur beat;

beat - (now % beat) => now;

int t;

for (0 => int j; j< 120; j++) {
	j % select.cap() => t;
	if(select[t] == -1) 0 => k.noteOff;
	else {
		Std.mtof(midiBase+notes[select[t]]) => k.freq;
		1 => k.noteOn;
	}
	1 => bar.noteOn;
	beat => now;
}