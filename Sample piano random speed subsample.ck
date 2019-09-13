3 => float gainSet; 
75::second => dur length;

SndBuf2 buf => NRev rev => ADSR env => Echo echo => Dyno dyn => dac;
"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => buf.read;
buf.samples() => buf.pos;

60./80.*8 => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

gainSet => buf.gain;

.4 => rev.mix;

5*beat => echo.max;
1.5*beat => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

0 => buf.loop;

(.5*beat,0.1*beat,1.,.5*beat) => env.set;

now + length => time future;

while (now < future) {
	Std.rand2(0,buf.samples()) => buf.pos;
	Std.rand2f(0.5,2.0) => buf.rate;
	if(Std.rand2f(0,1) > .5 ) -1*buf.rate() => buf.rate;
	<<< "buf rate, pos" , buf.rate(), buf.pos() >>>;
	1 => env.keyOn;
	<<< "Key on" >>>;
	.5*beat => now;
	1 => env.keyOff;
	<<< "Key off" >>>;
	.5*beat => now;
}
<<< "ending ">>>;

6*beat => now;