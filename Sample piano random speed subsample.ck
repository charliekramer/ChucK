1 => float gainSet;

SndBuf2 buf => NRev rev => ADSR env => Echo echo => Dyno dyn => dac;
"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => buf.read;
buf.samples() => buf.pos;

60./80.*8 => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

gainSet => buf.gain;

.0 => rev.mix;

5*beat => echo.max;
1.5*beat => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

1 => buf.loop;

(.55*beat,0.1*beat,.9,.55*beat) => env.set;

now + 75::second => time future;

while (now < future) {
	Std.rand2(0,buf.samples()) => buf.pos;
	Std.rand2f(0.5,2.0) => buf.rate;
	if(Std.rand2f(0,1) > .5 ) -1*buf.rate() => buf.rate;
	<<< "buf rate, pos" , buf.rate(), buf.pos() >>>;
	1 => env.keyOn;
	.5*beat => now;
	1 => env.keyOff;
	.5*beat => now;
}
<<< "ending ">>>;

6*beat => now;