class KickDrum extends Chubgraph {
	
SinOsc kick => ADSR env => PitShift pit => HPF filt => Dyno dyn => outlet;

(1::samp, 100::ms, .0, 3::second) => env.set;

1 => pit.shift;
1 => pit.mix;

40 => kick.freq;
80 => filt.freq;
2 => filt.Q;

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
fun void gain (float gainTemp) {
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
	fun void gain (float gainTemp) {
		gainTemp => snareSin.gain;
		gainTemp => snareNoise.gain;
	}
	*/
	
}

.1 => float masterGain;

120./94.*.25 => float beatSec; // *.25  // half time for rolls
beatSec::second => dur beat;

beat - (now % beat) => now;

KickDrum kick => Echo echo => NRev rev  => Dyno dyn1 => dac;
KickDrum tom => echo => rev => Dyno dyn2 => dac;
SnareDrum snare => echo => rev => Dyno dyn3 => dac;

masterGain => kick.gain => tom.gain => snare.gain;

.01 => rev.mix;

5*beat=> echo.max;
beat*1.5 => echo.delay; //1.5; 1.75 cool; 2.25
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

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