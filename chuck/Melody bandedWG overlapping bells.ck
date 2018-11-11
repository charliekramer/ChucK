// bowed bells plus 1/10 chance of bowed string
// length set below;

3::minute => dur length;
.005 => float gainSet;

8 => int nOsc;
BandedWG bnd[nOsc];
ADSR env[nOsc];
Echo echo[nOsc];
PRCRev rev[nOsc];
Dyno dyn[nOsc];
Gain bndGain[nOsc];
Pan2 panEcho[nOsc];
Pan2 panDry;

71-24 => int midiBase;

60./90. => float beatsec;
beatsec::second => dur beat;

for (0 => int i; i<nOsc; i++) {	
    bnd[i] => env[i] => echo[i] =>  rev[i] =>  dyn[i] => bndGain[i] => panEcho[i] => dac;
    bnd[i] => env[i] => bndGain[i] =>  panDry => dac;
	gainSet => bndGain[i].gain;
	
	Std.mtof(midiBase) => bnd[i].freq;
     .1 => bnd[i].bowPressure; // 0 = ring out
	 .1 => bnd[i].bowRate;
      1 => bnd[i].preset;
     .7 => bnd[i].startBowing;
	 
	 (100::ms,10::ms,.9, beat) => env[i].set;
	 
	 10*beat => echo[i].max;
     1.5*beat => echo[i].delay;
    .7 => echo[i].gain;
    .5 => echo[i].mix;
     echo[i] => echo[i];

     -.5 => panEcho[i].pan;
}

[4,7,12] @=> int notes[];

.5 => panDry.pan;

1 => bnd[0].pluck; // establish root
1 => env[0].keyOn;
4*beat => now;

0 => int j;

now + length => time future;

while (now < future) {
    j++; if (j > nOsc-1) 0 => j;
	spork~strike(j);	
	if (Std.rand2f(0.,1.) > 0.9) bow(bnd[j].freq()*2.,beat);
	Std.rand2(1,4)*beat => now;
	1 => env[j].keyOff;
	if (j == nOsc-1) {
		<<< "cleaning ", j >>>;
		8*beat => now;
	}
}

<<< "ending" >>>;
Std.mtof(midiBase) => bnd[0].freq;
1 => bnd[0].pluck; // finish with root
1 => env[0].keyOn;
beat => now;
1 => env[0].keyOff;
16*beat => now;

fun void strike (int j) {
	Std.mtof(midiBase+Std.rand2(0,1)*notes[Std.rand2(0,notes.cap()-1)]) => bnd[j].freq;
	1 => env[j].keyOn;
	<<< "fire", j >>>;
	.7 => bnd[j].startBowing;
}

fun void bow (float freq, dur duration) {
	
    Bowed bow => ADSR adsr => Echo echo => PRCRev rev => Gain g => dac;

    .9 => rev.mix;

    15::second => echo.max;
    .75::second => echo.delay;
    .7 => echo.gain;
    .5 => echo.mix;
    echo => echo;

    .9 => g.gain;

    (1::second, 1::second, .9, duration) => adsr.set;

    .5 => bow.bowPressure;
    .5 => bow.bowPosition;
     5 => bow.vibratoFreq;
    .02 => bow.vibratoGain;
    .5 => bow.volume;
	freq => bow.freq;
	1 => bow.startBowing;
	1 => adsr.keyOn;
	duration*2 => now;
	1 => adsr.keyOff;
	duration*2 => now;
	1 => bow.stopBowing;
	
}
	

