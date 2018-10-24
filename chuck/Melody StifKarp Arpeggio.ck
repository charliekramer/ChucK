StifKarp stk => Chorus chorus => Echo echo => NRev rev => Gain gain => dac;

 .5 => chorus.modFreq;
 .2 => chorus.modDepth;
 .5 => chorus.mix;

.2::second => dur noteDur;

noteDur - (now % noteDur) => now;

.3 => rev.mix;

10::second => echo.max;
noteDur*1.5 => echo.delay;
.5 => echo.gain;
.2 => echo.mix;
echo => echo;

57-24 => int midiNote;

now + 100::second => time future;

while ( now < future) {

for (1 => int i; i <4; i++ ) {
	
   playNote (noteDur, midiNote);
   noteDur => now;
   playNote (noteDur, midiNote+5);
   noteDur => now;
    playNote (noteDur, midiNote+12);
   noteDur => now;
    playNote (noteDur, midiNote+5);
   noteDur => now;
}
   playNote (noteDur, midiNote+10);
   noteDur => now;
   playNote (noteDur, midiNote+9);
   noteDur => now;
   playNote (noteDur, midiNote+7);
   noteDur => now;
   playNote (noteDur, midiNote+5);
   noteDur => now;

}


1::second => now;


fun void playNote (dur noteDur, int midiNote) {
	Std.mtof(midiNote) => stk.freq;
	1 => stk.noteOn;
	noteDur => now;
	1 => stk.noteOff;
}