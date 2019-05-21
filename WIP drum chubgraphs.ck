class KickDrum extends Chubgraph {
	
SinOsc kick => ADSR env => PitShift pit => HPF filt => Dyno dyn => outlet;

(1::samp, 100::ms, .0, 3::second) => env.set;

1 => pit.shift;
1 => pit.mix;

40 => kick.freq;
80 => filt.freq;
2 => filt.Q;
/*
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
	
	fun void gain (float gainTemp) {
		gainTemp => snareSin.gain;
		gainTemp => snareNoise.gain;
	}
	
}


KickDrum kick;
KickDrum tom;
SnareDrum snare;

2 => tom.pitch;

while (true) {
	1 => kick.noteOn;
	.25::second => now;
	1 => kick.noteOff;
	.25::second => now;
	
	1 => tom.noteOn;
	.25::second => now;
	1 => tom.noteOff;
	.25::second => now;
	
	1 => kick.noteOn;
	.25::second => now;
	1 => kick.noteOff;
	.25::second => now;
	
	1 => snare.noteOn;
	.25::second => now;
	1 => snare.noteOff;
	.25::second => now;
	
}