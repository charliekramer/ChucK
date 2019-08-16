
2 => float gainSet;

SndBuf2 buf => HPF hfilt => LPF filt => NRev rev => ADSR env => Echo echo => Dyno dyn => dac;
"/Users/charleskramer/Desktop/chuck/audio/342-016a_gap.wav" => buf.read;
buf.samples() => buf.pos;

// weird option--use BRF instead of HPF above (meant to clean clicking) 
// and set 1 => hfilt.Q and 1 => hfilt.freq;

.75 => float rateMin;
1.5 => float rateMax;

1 => int sporkFilter;
60*2 => float filtFreq; 8 =>  gainSet;

30::second => dur length;

60./80.*8 => float beatSec;
beatSec::second => dur beat;
//beat - (now % beat) => now;

gainSet => buf.gain;

1 => hfilt.Q;
20 => hfilt.freq;

4 => filt.Q;
filtFreq => filt.freq;

.2 => rev.mix;

5*beat => echo.max;
1.5*beat => echo.delay;
.5 => echo.gain;
.0 => echo.mix;
echo => echo;

1 => buf.loop;

(.5*beat,0.1*beat,.9,.55*beat) => env.set;

now + length => time future;

if (sporkFilter ==1 ) spork~sweep_filt(filtFreq);

while (now < future) {
	Std.rand2(0,buf.samples()) => buf.pos;
	Std.rand2f(rateMin,rateMax) => buf.rate;
	if(Std.rand2f(0,1) > .5 ) -1*buf.rate() => buf.rate;
	<<< "buf rate, pos" , buf.rate(), buf.pos() >>>;
	1 => env.keyOn;
	.5*beat => now;
	1 => env.keyOff;
	.5*beat => now;
}
<<< "ending ">>>;

6*beat => now;

fun void sweep_filt(float baseFreq) {
	while(true) {
		
		env.value()*baseFreq => filt.freq;
		1::ms => now;
	}
}
