.1 => float sinGain;
.2 => float rhodesGain;

adc => Gain g =>blackhole; 
SinOsc s1 => PitShift pitch1 => ADSR env => Echo echo1 => NRev rev1 => dac;
SinOsc s2 => PitShift pitch2 => env => Echo echo2 => NRev rev2 => dac;
SinOsc s3 => PitShift pitch3 => env => Echo echo3 => NRev rev3 => dac;

20 => g.gain;

Rhodey rhodes => PitShift pitchRhodes => dac;
rhodesGain => rhodes.gain;

(.2::second, .2::second, .9, .5::second) => env.set;

1 => pitchRhodes.mix;

0 => int doRhodes;
 => int doSin; doSin*sinGain => sinGain;
sinGain => s1.gain => s2.gain => s3.gain;

.2 => rev1.mix => rev2.mix => rev3.mix;

5::second => echo1.max => echo2.max => echo3.max;
.3 => echo1.mix => echo2.mix => echo3.mix;
.5 => echo1.gain => echo2. gain => echo3.gain;
1.5::second => echo1.delay;
.5::second => echo2.delay;
.11::second => echo3.delay;
echo1 => echo1;echo2 => echo2;echo3 => echo3;

.1 => float floor;
1 => float thresh1;
.4 => float thresh2;
1 => pitch1.mix => pitch2.mix => pitch3.mix;

if (doRhodes == 1) {
	
	while (true) {
		
		if (g.last() > floor) {
			Std.fabs(g.last())   =>  pitchRhodes.shift;
			1 => rhodes.noteOn;
			1::samp => now;
		}
		1::samp => now;
	}
}

if (doSin == 1) {
	
	while (true) {
		
		if (g.last() > floor) {
			Std.fabs(g.last()*4)   =>  pitch1.shift;
			Std.fabs(g.last()*4)+1 =>  pitch2.shift;
			Std.fabs(g.last()*4)+3 =>  pitch3.shift;
			1 => env.keyOn;
			.4::second => now;
		}
		1::samp => now;
		1 => env.keyOff;
	}
}



/* threshold code--needs work
while (true) {
	
	if (g.last() > floor && g.last() < thresh1) {
		Std.fabs(g.last())+1 =>  pitch1.shift;
	}
	else if (g.last() > thresh1 && g.last() < thresh2) {
		Std.fabs(g.last())+1 =>  pitch2.shift;
	}
	else {
		Std.fabs(g.last())+1 =>  pitch3.shift;
	}
		//1 => s.noteOn;
	1::samp => now;
}
*/
100::second => now;
