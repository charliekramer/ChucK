.3 => float gainSet;

5 => int n;

SndBuf2 buf[n];
Echo echo[n];
ADSR env[n];
Pan2 pan[n];
Pan2 panEcho[n];
NRev rev[n];

"/Users/charleskramer/Desktop/chuck/audio/concrete_1.wav" => buf[0].read;
"/Users/charleskramer/Desktop/chuck/audio/concrete_2.wav" => buf[1].read;
"/Users/charleskramer/Desktop/chuck/audio/concrete_3.wav" => buf[2].read;
"/Users/charleskramer/Desktop/chuck/audio/concrete_4.wav" => buf[3].read;
"/Users/charleskramer/Desktop/chuck/audio/concrete_5.wav" => buf[4].read;

60./80.*2 => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

5*beat => dur echoMax;
.125*beat => dur echoDelay;
.5 => float echoGain;
.5 => float revMix;
.3 => float bufRate;
0 => int bufLoop;

[3,4,5] @=> int fire_index[];

for (0 => int i; i< n; i++) {
	gainSet => buf[i].gain;
	bufLoop => buf[i].loop;
	bufRate => buf[i].rate;
	1 => buf[3].rate;
	buf[i] => env[i] => pan[i] => dac;
	env[i] => echo[i] => rev[i] => panEcho[i] => dac;
	revMix => rev[i].mix;
	-1+ i*2./(1.*(n-1))  => pan[i].pan; 
	-1*pan[i].pan() => panEcho[i].pan;
	1 => echo[i].mix;
	echoMax => echo[i].max;
	echoDelay => echo[i].delay;
	echoGain => echo[i].gain;
	echo[i] => echo[i];
	(.1*beat,.01*beat,0,.01*beat) => env[i].set;
}



60::second => dur length;

now + length => time future;

0 => int j;

while (now < future) {
	
	//Std.rand2(0,n-1) => j;
	spork~fire(3);
	spork~fire(j%fire_index[0]);
	spork~fire(j%fire_index[1]);
	spork~fire(j%fire_index[2]);

	.25*beat => now;
	
	j++;
	
}

for (0 => int i; i < n; i++) {
	buf[i].samples() => buf[i].pos;
}

15::second => now;
	
fun void fire(int j) {
	<<< "j", j >>>;
	Std.rand2(0,0*buf[j].samples()) => buf[j].pos;
	1 => env[j].keyOn;
	.25*beat => now;
	1 => env[j].keyOff;
	.25*beat => now;
	buf[j].samples() => buf[j].pos;
}

