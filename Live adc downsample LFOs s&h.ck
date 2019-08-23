
adc => Gain s => blackhole;
SinOsc LFO1 => blackhole;
SinOsc LFO2 => blackhole;
Step imp => PitShift pitch => Echo e => dac;

1 => pitch.mix;

.9 => float gainSet;

float loop[20000];
1 => int looping;
4 => int nLoops;
1 => int nRand;
nLoops => int loopMax;
1 => int loopLo;
10 => int loopHi;
//Std.rand2(loopLo,loopHi)::samp => now;
1 => int pitchRand; //randomize pitch of loop
.7 => float pitchLo;
1.5 => float pitchHi;


0 => int randomize; // multiply last samp * uniform
.8 => float lower;
1.2 => float upper;

gainSet => imp.gain;

1 => pitch.mix;
1 => pitch.shift => float basePitch;

.2 => LFO1.freq;
.1 => LFO1.freq;

.6 => float a;
1 => float b1 => float b2;
2 => float c;
1 => float d;
//(a*((Math.fabs(LFO1.last())*b1+Math.fabs(LFO2.last())*b2)+c)+d)::ms => now;


5::second => e.max;
1.5::second => e.delay;
.5 => e.gain;
0. => e.mix;
e => e;


float holder;


now + 300::second => time future ;

while (now < future) {
	s.last() => holder;
	s.last() => imp.next;
	1::samp => now;	
	holder => imp.next;
	
	if (randomize == 1) Std.rand2f(lower,upper)*holder => imp.next;
	
	//(a*((Math.fabs(LFO1.last())*b1+Math.fabs(LFO2.last())*b2)+c)+d)::ms => now;
	
	1::samp => now;
	
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
	
}

0 => s.gain;
10::second => now;


