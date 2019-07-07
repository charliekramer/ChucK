BandedWG bnd[3];
Echo echo[3];
PRCRev rev[3];
Dyno dyn[3];
Gain bndGain[3];
Pan2 panEcho[3];
Pan2 panDry;

55 => int midiBase;

60./94. => float beatsec;
beatsec::second => dur beat;

for (0 => int i; i<3; i++) {	
    bnd[i] => echo[i] =>  rev[i] =>  dyn[i] => bndGain[i] => panEcho[i] => dac;
    bnd[i] => bndGain[i] =>  panDry => dac;
	.2 => bndGain[i].gain;
	
	Std.mtof(midiBase) => bnd[i].freq;
    .0 => bnd[i].bowPressure; // 0 = ring out
     1 => bnd[i].preset;
     1 => bnd[i].pluck;
	 
	 10*beat => echo[i].max;
     1.5*beat => echo[i].delay;
    .7 => echo[i].gain;
    .5 => echo[i].mix;
     echo[i] => echo[i];

     -.5 => panEcho[i].pan;
}

[4,7,12] @=> int notes[];

.5 => panDry.pan;

1 => bnd[2].pluck; // establish root
4*beat => now;

0 => int j;

while (true) {
	
	Std.rand2(0,2) => j;
	spork~strike(j);	
	Std.rand2(1,4)*beat => now;
}

fun void strike (int j) {
	Std.mtof(midiBase+Std.rand2(0,1)*notes[Std.rand2(0,2)]) => bnd[j].freq;
	1 => bnd[j].pluck;
}

