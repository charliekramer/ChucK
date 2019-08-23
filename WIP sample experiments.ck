
SndBuf s => blackhole;
SinOsc LFO1 => blackhole;
SinOsc LFO2 => blackhole;
Step imp => PitShift pitch => Echo e => dac;

1 => pitch.mix;

.1 => float gainSet;

gainSet => imp.gain;

1 => pitch.mix;

.2 => LFO1.freq;
.1 => LFO1.freq;

.4 => float a;
1 => float b1 => float b2;
200 => float c;

//a*((Math.fabs(LFO1.last())*b1+Math.fabs(LFO2.last())*b2)+c)::ms => now;

5::second => e.max;
1.5::second => e.delay;
.5 => e.gain => e.mix;
e => e;

"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano_edit.wav" => s.read;
0 => s.pos;
1 => s.loop;

float holder;


now + 100::second => time future ;

while (now < future) {
	s.last() => holder;
	s.last() => imp.next;
	1::samp => now;	
	holder => imp.next;
	a*((Math.fabs(LFO1.last())*b1+Math.fabs(LFO2.last())*b2)+c)::ms => now;
}



