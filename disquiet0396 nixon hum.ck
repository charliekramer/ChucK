SndBuf buffer[3];
Echo echo[3];
ADSR env[3];
Pan2 pan[3];
PitShift pitch[3];
LPF filter[3];

1 => int chooser;

float pitches[];

if (chooser == 1) {
	[.75,1] @=> pitches;
}
else if (chooser == 2) {
	[.5,.75,1,1.5,2.] @=> pitches;
}
else if (chooser == 3) {
	[.75,1,1.5] @=> pitches;
}
else  {
	[.5,.75,1,1.5,2.] @=>  pitches;
}

60./80.*.5 => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;


for (0 => int i; i < buffer.size(); i++) {
	
	"/Users/charleskramer/Desktop/chuck/audio/18mingap_hum.wav" => buffer[i].read;
    buffer[i] => pitch[i] => echo[i] => env[i] => pan[i] => dac;
	buffer[i].samples() => buffer[i].pos;
	1 => pitch[i].mix;
	5*beat => echo[i].max;
	1.5*beat => echo[i].delay;
	.3 => echo[i].mix;
	.5 => echo[i].gain;
	echo[i] => echo[i];
	(.25*beat,.25*beat, 1.0, 4*beat) => env[i].set;
	

}


-1. => pan[0].pan;
0. => pan[1].pan;
1. => pan[2].pan;


int j;
float p;

now + 64*beat => time future;

while (now < future) {
	
	Std.rand2(0,buffer.size()-1) => j;
	
	pitches[Std.rand2(0,pitches.size()-1)] => p;
	
	note(j,1,p);
	note(j,0,p); 
	
}

10::second => now;

fun void note(int i, int onOff, float pitchF) {
	
	<<< i, onOff, pitchF>>>;
	
	if (onOff == 1)  {
		1 => env[i].keyOn;
		pitchF => pitch[i].shift;
		0 => buffer[i].pos;
		beat => now; 
	}
	else {
		1 => env[i].keyOff;
		buffer[i].samples() => buffer[i].pos;
	}

}


