// pulls random loops off sample

SndBuf2 buffer => Gain inGain => Dyno dyn => HPF l =>  Echo echo => NRev rev => Gain outGain => dac;
buffer =>  inGain =>  dyn =>  l =>  LiSa loop => echo => PitShift pitch => rev =>   Gain loopGain => Pan2 loopPan =>dac;

"/Users/charleskramer/Desktop/chuck/audio/apache_break_editor.wav" => buffer.read;

20 => l.freq;
10 => l.Q;


0.02 => inGain.gain;
0.8 => outGain.gain;
0.3 => loopGain.gain;

60./120. => float beatsec;
beatsec::second => dur beat;
beat - (now % beat) => now;

120./138. => buffer.rate;

[.25,.5,1., 2.] @=> float glitchArray[];

10::second => echo.max;

beatsec::second*1.5 => echo.delay;

.7 => echo.gain;
.2 => echo.mix;
echo => echo;

.1 => rev.mix;

1 => pitch.mix;

float randLength;
int numLoops;

spork~loopit(beat*4);

now + 360::second => time future;

int numBeats;

while (now < future) {
	
	Std.rand2(1,4) => numBeats;
	
	numBeats*beatsec => randLength;
	
	randLength::second =>loop.duration;
	
	loop.record(1);
	
	randLength::second => now;
	
	loop.record(0);
	
	loop.rampUp(1::ms);
	
	glitchArray[Std.rand2(0,glitchArray.cap()-1)] => loop.rate;
	
	Std.rand2(2,2) => numLoops;
	
	Std.rand2f(-1,1) => loopPan.pan;
	
	Std.rand2f(.5,2) => pitch.shift;
	
	<<< "length" , randLength, "rate", loop.rate(), "numLoops", numLoops, "pan", loopPan.pan(), "pitch", pitch.shift() >>> ;

//	if (now % beat == 0::second) 0  => buffer.pos;

    1 => loop.gain;

	for (1 => int i; i < numLoops; i++) {
		
		randLength::second => now;
		loop.gain()*.75 => loop.gain;
	}	
	0 => buffer.pos;
	if (false) { // last
		
		for (1 => int i; i < 10; i++) {
			<<< "loop" , i, "gain", loop.gain() >>>;
			randLength::second => now;
			loop.gain()*.5 => loop.gain;
		}	
		
		break;
	}
		
	
}

fun void loopit (dur length) {
	while (true) {
		0 => buffer.pos;
		length => now;
	}
}
	
/*
4::second => loop.duration;

loop.record(1);

4::second => now;

loop.record(0);

loop.rampUp(10::ms);
*/

100::second => now;