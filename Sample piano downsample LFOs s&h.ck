
SndBuf s => blackhole;
SinOsc LFO1 => blackhole;
SinOsc LFO2 => blackhole;
Step imp => PitShift pitch => Echo e => dac;


.9*1.5 => float gainSet;

45::second => dur length;

1 => int LFOs; // use LFO for play length

float loop[41000];
1=> int looping;
3 => int nLoops;
1 => int nRand;
nLoops => int loopMax;
1 => int loopLo;
3 => int loopHi;
//Std.rand2(loopLo,loopHi)::samp => now;
1 => int pitchRand; //randomize pitch of loop
.5 => float pitchLo;
2.5 => float pitchHi;

0 => int randEcho; // randomize echo time


.5 => pitch.mix;

0 => int randomize; // multiply last samp * uniform
.8 => float lower;
1.2 => float upper;

gainSet => imp.gain;

.5 => pitch.mix;
1 => pitch.shift => float basePitch;

1 => s.rate;

.2 => LFO1.freq;
.1 => LFO1.freq;

.6 => float a;
1 => float b1 => float b2;
2 => float c;
1 => float d;
//(a*((Math.fabs(LFO1.last())*b1+Math.fabs(LFO2.last())*b2)+c)+d)::ms => now;


5::second => e.max;
1.5::second*.75 => dur delayTime;
delayTime => e.delay;
.5 => e.gain;
0.3 => e.mix;
e => e;


"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano_edit.wav" => s.read;
"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => s.read;
//"/Users/charleskramer/Desktop/chuck/audio/apache_break_editor.wav" => s.read;

0 => s.pos;
1 => s.loop;

float holder;


now + length => time future ;

while (now < future) {
	s.last() => holder;
	
	// s.last() => imp.next; 1::samp => now; holder => imp.next;
	
	if (randomize == 1) Std.rand2f(lower,upper)*holder => imp.next;
	
	if (LFOs ==1 ) (a*((Math.fabs(LFO1.last())*b1+Math.fabs(LFO2.last())*b2)+c)+d)::ms => now;
	
	if (looping == 1) {
		
		0 => imp.next;
		
		for (0 => int i; i < loop.size() -1; i++) {
			s.last() => loop[i];
			1::samp => now;
		}
		
		if (nRand == 1) Std.rand2(1, loopMax) => nLoops;
		
		for (0 => int j; j < nLoops; j++) {
	
			if (pitchRand == 1) Std.rand2f(pitchLo, pitchHi) => pitch.shift;
		
			for (0 => int i; i < loop.size() -1; i++) {
				loop[i] => imp.next;
				Std.rand2(loopLo,loopHi)::samp => now;
			}
			
			
		}
		
	basePitch => pitch.shift;
	
	}
	
	if (randEcho == 1) {
		delayTime*(1+Std.rand2(-1,2)*.5) => e.delay;
		<<< "delay reset" >>>;
	}
	if ((LFOs == 0) && (looping == 0) ) 1::samp => now;
}

0 => s.gain;
10::second => now;



		
	

