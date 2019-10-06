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

1 piano notes
2 lawnmower
3 a fountain at the Watergate hotel
4 sounds made by the planet Saturn
5 random voice mail left by some telemarketer
6 a crosswalk light saying "wait"

then I put the samples in a list (1 to 6) and ran through each one, doing two things:
1. adding or subtracting a function of the sample just before it in the list
2. skipping a number of milliseconds (basically downsampling) with the skip size
dependent on the value of the other sample

when I fiddled with the parameters of these two functions, some really interesting 
tones emerged. I also got a ton of high-frequency noise, so I applied 
an actual low-pass filter that I swept using two LFOs.

*/