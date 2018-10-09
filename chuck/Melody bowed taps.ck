// notes for taps on bowed instrument
// two minute limit

Bowed bow => ADSR adsr => Echo echo => PRCRev rev => Gain g => Pan2 p => dac;

.9 => rev.mix;

5::second => echo.max;
.75::second => echo.delay;
.7 => echo.gain;
.5 => echo.mix;
echo => echo;

.2 => g.gain;

(1::second, 1::second, .9, 1::second) => adsr.set;

.5 => bow.bowPressure;
.5 => bow.bowPosition;
5 => bow.vibratoFreq;
.02 => bow.vibratoGain;
.5 => bow.volume;

58 => int baseNote;
baseNote - 5 => int fifthNote;
baseNote + 4 => int thirdNote;

[fifthNote,baseNote,thirdNote] @=> int notes[];

now + 120::second => time future;

while (now < future) {
	
	spork~bowNote(Std.mtof(notes[Std.rand2(0,2)]),Std.rand2f(4,7)::second);
	Std.rand2f(2,5)::second => now; // make very short for symphonic effect
}
	
spork~bowNote(Std.mtof(notes[1]),10::second); //last note

20::second => now;

fun void bowNote (float freq, dur noteDur) {
	freq => bow.freq;
	Std.rand2f(3.5,7.5) => bow.vibratoFreq;
	Std.rand2f(-.25,.25) =>p.pan;
	1=>bow.startBowing;
	1=>adsr.keyOn;
	noteDur => now;
	1 => adsr.keyOff;
	noteDur => now;
	1=>bow.stopBowing;
}
