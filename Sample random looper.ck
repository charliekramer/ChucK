// pulls random loops off sample

.15*20 => float gainSet;
45::second => dur length;

SndBuf2 buffer => Gain inGain => Dyno dyn => HPF l =>  Echo echo => NRev rev => Gain outGain => Gain gain => dac;
buffer =>  inGain =>  dyn =>  l =>  LiSa loop => echo => PitShift pitch => rev =>   Gain loopGain => Pan2 loopPan => gain => dac;

SinOsc sin => gain => dac;
0 => sin.gain; // run ringmod to make this work with 3 => gain.op;
//spork~ringmod(6,200); //gain, freq

"/Users/charleskramer/Desktop/chuck/audio/apache_break_editor.wav" => buffer.read;
138 => float loopSpeed; // native speed of loop

//"/Users/charleskramer/Desktop/chuck/audio/loopermanferryterry101bpmjazzsambadrum.wav" => buffer.read;
///101 => loopSpeed;

//"/Users/charleskramer/Desktop/chuck/audio/looperman-83bpm-l-0850517-0116649-miazyo-sazzyjazzydrumlings.wav" => buffer.read;
//83 => loopSpeed;

//"/Users/charleskramer/Desktop/chuck/audio/looperman-1564425-0149579-brisk-bossa-nova-drumgroove.wav" => buffer.read;
//87 => loopSpeed;

22 => l.freq;
10 => l.Q;

gainSet=> float masterGain;

buffer.samples()=>buffer.pos; // so it doesn't play during the synch


//208.8*.5 => float BPM; // set this to fix below
94 => float BPM; // set this to desired BPM

60./BPM => float beatsec;
beatsec::second => dur beat;
0 => inGain.gain;
beat - (now % beat) => now;

0.02 => inGain.gain;
0.8*masterGain => outGain.gain;
0.8*masterGain => loopGain.gain; //.3?

BPM/loopSpeed => buffer.rate; // loopSpeed is native speed of loop

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

now + length => time future;

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

me.exit();

fun void loopit (dur length) {
	while (true) {
		0 => buffer.pos;
		length => now;
	}
}

fun void ringmod(float _gain, float _freq) {
    3 => gain.op;
    _gain => sin.gain;
    while (true) {
        beat => now;
        Std.rand2f(.7,1.5)*_freq => sin.freq;
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