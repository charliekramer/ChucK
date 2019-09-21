6 => int n;

SndBuf buf[n];
dur length[n];
Impulse imp => LPF filter => NRev rev => Dyno dyn => dac;

880 => filter.freq;
2 => filter.Q;

.2 => rev.mix;

-.5 => float fraction; // how much of 
8 => float jump; // ms to add to skip value derived from sample 2
.5 => float skipCoeff; // coefficent on abs sample in skipper 

spork~filt_sweep();


for (0 => int i; i < buf.cap(); i++) {
	buf[i].samples() => buf[i].pos;
	buf[i] => blackhole;
	buf[i].samples()*1::samp => length[i];
	1 => buf[i].rate;
	0 => buf[i].loop;
}
"/Users/charleskramer/Desktop/chuck/audio/disquiet0402_piano.wav" => buf[0].read;
"/Users/charleskramer/Desktop/chuck/audio/disquiet0402_mowing.wav" => buf[1].read;
"/Users/charleskramer/Desktop/chuck/audio/disquiet0402_watergate.wav" => buf[2].read;
"/Users/charleskramer/Desktop/chuck/audio/disquiet0402_saturn.wav" => buf[3].read;
"/Users/charleskramer/Desktop/chuck/audio/disquiet0402_voicemail.wav" => buf[4].read;
"/Users/charleskramer/Desktop/chuck/audio/disquiet0402_wait.wav" => buf[5].read;


int i;
int j;
float skip;

for (0 => int i; i < buf.cap(); i++) {
	
	<<< i >>>;
	
	now + 5::second => time future;
	i - 1 => j;
	if (j == -1 ) buf.cap()-1 => j;
	<<< i, j>>>; 
	
	0 => buf[i].pos;
	0 => buf[j].pos;
	
	while (now < future) {
		(1+buf[i].last())+fraction*Math.sqrt(Math.fabs(buf[j].last())) => imp.next;
		1::samp => now;
		buf[i].last() => imp.next;
		Math.fabs(buf[j].last())*skipCoeff+jump => skip;
		skip::ms => now;
	}
	
}

10::second => now;

fun void filt_sweep () {
	SinOsc sin => blackhole;
	SinOsc sin2 => blackhole;
	.2 => sin.gain;
	.05 =>sin2.gain;
	.1 => sin.freq;
	3.2 => sin2.freq;
	while (true) {
		(1+sin.last())*(1+sin2.last())*880 => filter.freq;
		1::samp => now;
	}
}
	
/*
 thought it would be interesting to see what it sounded like to use samples to process other samples. So Ioaded up six samples, some of which I've used for other Junto stuff:

-piano notes
-lawnmower
-a fountain at the Watergate hotel
-sounds made by the planet Saturn
-random voice mail left by some telemarketer
- a crosswalk light saying "wait"

then I put the samples in a list and rand down the list successively playing each sample. But for each sample I did two operations using the value of the previous sample in the list:

1. subtracted 1/2 the square root of the absolute value of the previous sample (why this weird function? i experimented and came up with this. It sounded interesting.)
2. I played the original sample but skipped the number of milliseconds corresponding to a number called "skip" (basically downsampling, I suppose) . Skip was set equal to the absolute value of the previous sample plus a variable called "jump". I had to put jump in there because the program would hang if I didn't. I think that's because sometimes the sample value is zero (silence). Anyway fiddling with "jump" made some cool stuff happen.

All this messing around with the sample created a lot of painful high frequency noise so I added an actual (low pass) filter that I then swept using two sine LFOs. I also ran the output through a reverb.

The whole program ran around 30 seconds so I triggered multiple copies with decreasing values of "jump". Fun!

*/