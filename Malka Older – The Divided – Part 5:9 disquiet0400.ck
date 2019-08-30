// also run; sample random looper.ck
SndBuf2 buf => dac;
Wurley wurley[3];
Echo echo;
HPF filt;
NRev rev;
Chorus chorus;
for (0 => int i; i< wurley.size(); i++) {
	wurley[i]=> filt => chorus => echo => NRev rev => dac;
	.05 => wurley[i].gain;
	.2 => wurley[i].controlOne;
}

"/Users/charleskramer/Desktop/chuck/audio/The_Divided_-_5_of_9.wav" => buf.read;

40 => filt.freq;
2 => filt.Q;

1.5 => buf.gain;

0 => buf.pos;

.9 => rev.mix;
.5 =>chorus.mix;
.3 => chorus.modFreq;
.2 => chorus.modDepth;

58-12 => float midiBase;

[3.,5.,6.,7.,8.,10.,12.,14.] @=> float notes[];

60./80. => float beatSec;
beatSec::second => dur beat;

4*beat => echo.max;
beat => echo.delay;
.3 => echo.mix;
.5 => echo.gain;
echo => echo;

3.8::second => now;

1 => int nNotes;

play(nNotes);

8*beat => now;

now + 1::second*buf.samples()/41000 - 3.8::second - 16*beat=> time future;

for (0 => int i; i< wurley.size(); i++) {
	1 => wurley[i].noteOff;
}

beat - (now % beat) => now;

while (now < future) {
	
	Std.rand2(0,3) => nNotes;
	play(nNotes);
	Std.rand2f(.3,.7) => chorus.modFreq;
	8*beat => now;
}

8*beat => now;

fun void play(int _nNotes) { 
	for (0 => int i; i < _nNotes; i++) {
		Std.mtof(midiBase+notes[Std.rand2(0,notes.size()-1)]) => wurley[i].freq;
		1 => wurley[i].noteOn;
	}
	Std.mtof(midiBase) => wurley[0].freq;
}


