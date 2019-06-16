StifKarp stk => PitShift pit =>Chorus chorus => Echo echo => NRev rev => Gain gain => dac;
SinOsc LFO => blackhole;

.3 => gain.gain;

.3 => stk.pickupPosition;
.1 => stk.sustain;
//1. => stk.stretch;

 .5 => chorus.modFreq;
 .2 => chorus.modDepth;
 .1 => chorus.mix;

60./94.*2. => float noteTime;

noteTime::second/4. => dur noteDur;

noteDur - (now % noteDur) => now;

1 => pit.shift;

1 => pit.mix;

spork~pitch(.0125,10.0); // freq, gain; .125,.0125 good freqs

.3 => rev.mix;

10::second => echo.max;
noteDur*1.5 => echo.delay;
.5 => echo.gain;
.2 => echo.mix;
echo => echo;

58-12-12 => int midiNote;

now + 100::second => time future;

while ( now < future) {

for (1 => int i; i <4; i++ ) {
	
   playNote (noteDur, midiNote);
   noteDur => now;
   playNote (noteDur, midiNote+7);
   noteDur => now;
    playNote (noteDur, midiNote+12);
   noteDur => now;
    playNote (noteDur, midiNote+7);
   noteDur => now;
}
   playNote (noteDur, midiNote+10);
   noteDur => now;
   playNote (noteDur, midiNote+9);
   noteDur => now;
   playNote (noteDur, midiNote+7);
   noteDur => now;
   playNote (noteDur, midiNote+4);
   noteDur => now;

}


1::second => now;


fun void playNote (dur noteDur, int midiNote) {
	Std.mtof(midiNote) => stk.freq;
	1 => stk.noteOn;
	noteDur => now;
	1 => stk.noteOff;
}

fun void pitch(float freq, float gain) {
	freq => LFO.freq;
	gain => LFO.gain;
	
	while (true) {
		LFO.last() => pit.shift;
		1::ms => now;
	}
}
	