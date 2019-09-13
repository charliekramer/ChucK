1 => float gainSet;

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

60./80.*4 => float beatSec;
beatSec::second => dur beat;

5*beat => dur echoMax;
.75*beat => dur echoDelay;
4 => float echoGain;
.2 => float revMix;
1 => float bufRate;
1 => int bufLoop;

for (0 => int i; i< n; i++) {
	bufLoop => buf[i].loop;
	bufRate => buf[i].rate;
	buf[i] => env[i] => pan[i] => dac;
	env[i] => echo[i] => rev[i] => panEcho[i] => dac;
	revMix => rev[i].mix;
	-1+ i*2./(1.*(n-1))  => pan[i].pan; 
	-1*pan[i].pan() => panEcho[i].pan;
	1 => echo[i].mix;
	echoMax => echo[i].max;
	echoDelay => echo[i].delay;
	echoGain => echo[i].gain;
	(.5*beat,.5*beat,1,.5*beat) => env[i].set;
}

int j;

15::second => dur length;

now + length => time future;

while (now < future) {
	
	Std.rand2(0,n-1) => j;
	
	spork~fire(j);
	.5*beat => now;
	
}

for (0 => int i; i < n; i++) {
	buf[i].samples() => buf[i].pos;
}

15::second => now;
	
fun void fire(int j) {
	<<< "j", j >>>;
	Std.rand2(0,buf[j].samples()) => buf[j].pos;
	1 => env[j].keyOn;
	beat => now;
	1 => env[j].keyOff;
	beat => now;
	buf[j].samples() => buf[j].pos;
}

