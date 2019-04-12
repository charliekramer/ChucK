4 => int nBuf;

SndBuf harmonic[nBuf];
PitShift pitch[nBuf];
Pan2 pan[nBuf];
NRev rev[nBuf];


-0.50 => pan[0].pan;
-0.25 => pan[1].pan;
0.25 => pan[2].pan;
0.50 => pan[3].pan;


for (0 => int i; i < harmonic.cap(); i++) {
	"/Users/charleskramer/Desktop/chuck/audio/harmonic.wav" => harmonic[i].read;
    harmonic[i] => pitch[i] => rev[i] => pan[i] => dac;
	.5 => harmonic[i].rate;
	1 => pitch[i].mix;
	0 => rev[i].mix;
}

60./120.*2 => float beatSec;
beatSec::second => dur beat;

[Std.mtof(58)/Std.mtof(60), Std.mtof(57)/Std.mtof(60), Std.mtof(56)/Std.mtof(60), Std.mtof(65)/Std.mtof(60), 1] @=> float fraction[];

for (0 => int i; i < fraction.cap(); i++) {
 	spork~play(0,1,8*beat);
 	beat*4 => now;
 	spork~play(1,fraction[i],8*beat);
 	beat*4 => now;
 	spork~play(2,Math.pow(fraction[i],2),8*beat);
 	beat*4 => now;
 	spork~play(3,Math.pow(fraction[i],3),8*beat);
 	beat*4 => now;
}

for (0 => int i; i <= 10; i++) {
	
	spork~revPlus(0,.1);
	spork~play(0,1,2*beat);
	beat => now;
	spork~revPlus(1,.1);
	spork~play(1,1,2*beat);
	beat*2 => now;
	
	gainDown(.85);
	
	spork~revPlus(0,.1);
	spork~play(0,1,2*beat);
	beat => now;
	spork~revPlus(1,.1);
	spork~play(1,1,2*beat);
	beat*2 => now;
	
	gainDown(.85);
	
	spork~revPlus(0,.1);
	spork~play(0,1,2*beat);
	beat => now;
	spork~revPlus(2,.1);
	spork~play(2,.47,2*beat);
	beat*2 => now;
	
	gainDown(.85);
	
	spork~revPlus(0,.1);
	spork~play(0,1,2*beat);
	beat => now;
	spork~revPlus(3,.1);
	spork~play(3,.47,2*beat);
	beat*4 => now;
	
	gainDown(.85);
	
}


8*beat =>now;

fun void play(int j, float pit, dur duration) {
	0 => harmonic[j].pos;
	pit => pitch[j].shift;
	duration => now;
}

fun void revPlus (int i, float increment) {
	rev[i].mix() + increment => rev[i].mix;
}

fun void gainDown(float ratio) {
	for (0 => int i; i < harmonic.cap(); i++) {
		harmonic[i].gain()*ratio => harmonic[i].gain;
	}
}
	