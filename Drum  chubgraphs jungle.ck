class KickDrum extends Chubgraph {
	
SinOsc kick => ADSR env => PitShift pit => HPF filt => Dyno dyn => outlet;

(100::samp, 75::ms, .0, 3::second) => env.set;

.7 => pit.shift;
1 => pit.mix;

44 => kick.freq;
35 => filt.freq;
3 => filt.Q; // crank it up for resonant bass

fun void noteOn (int noteTemp) {
	noteTemp => env.keyOn;
}

fun void noteOff (int noteTemp) {
	noteTemp => env.keyOff;
}


fun void pitch (float pitchTemp) {
	pitchTemp => pit.shift;
}

fun void filtFreq (float filtFreqTemp) {
	filtFreqTemp => filt.freq;
}
/*
fun float gain (float gainTemp) {
	gainTemp => kick.gain;
}
*/


}


class SnareDrum extends Chubgraph {
	
	SinOsc snareSin => ADSR env => PitShift pit =>  Dyno dyn => outlet;
	Noise snareNoise => ADSR envNoise => PitShift pitNoise => HPF filt => Dyno dynNoise => outlet;
	
	(1::samp, 10::ms, .0, 3::second) => env.set;
	(0::samp, 100::ms, .0, .3::second) => envNoise.set;
	
	1 => pit.shift;
	1 => pit.mix;
	
	1 => snareSin.gain;
	
	400 => snareSin.freq;
	100 => filt.freq;
	2 => filt.Q;
	
	
	
	fun void noteOn (int noteTemp) {
		noteTemp => env.keyOn;
		noteTemp => envNoise.keyOn;
	}
	
	fun void noteOff (int noteTemp) {
		noteTemp => env.keyOff;
		noteTemp => envNoise.keyOff;
	}
	
	
	fun void pitch (float pitchTemp) {
		pitchTemp => pit.shift;
	}
	
	fun void filtFreq (float filtFreqTemp) {
		filtFreqTemp => filt.freq;
	}
	
	/*	
	fun float gain (float gainTemp) {
		gainTemp => snareSin.gain;
		gainTemp => snareNoise.gain;
	}
	*/	
	
}

.02 => float masterGain;

float d1, d2; //beat divisors; for drums and echo

2 => d1; .125 => d2; // (.25, 1), (.25, 3) (.5, .5) (2,.125)

120./94*d1 => float beatSec; // *.25  // half time for rolls// or 1.0 if echo = .75*.5
beatSec::second => dur beat;

beat - (now % beat) => now;

KickDrum kick => Echo echo => NRev rev  => Dyno dyn1 => dac;
KickDrum tom => echo => rev => Dyno dyn2 => dac;
SnareDrum snare => echo => rev => Dyno dyn3 => dac;

masterGain => kick.gain => tom.gain => snare.gain => kick.gain;

.01 => rev.mix;

5*beat=> echo.max;
beat*1.5*d2 => echo.delay; //1.5; 1.75 cool; 2.25 // .75*.5 =f time = *1;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

1.0 => kick.pitch;

2 => tom.pitch;

while (true) {
	1 => kick.noteOn;
	.25*beat => now;
	1 => kick.noteOff;
	.25*beat => now;
	
	1 => tom.noteOn;
	Std.rand2f(.5,5) => tom.pitch;
	.25*beat => now;
	1 => tom.noteOff;
	.25*beat => now;
	
	1 => kick.noteOn;
	.25*beat => now;
	1 => kick.noteOff;
	.25*beat => now;
	
	1 => snare.noteOn;
	Std.rand2f(.5,5) => snare.pitch;
	.25*beat => now;
	1 => snare.noteOff;
	.25*beat => now;
	
}

