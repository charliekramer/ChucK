Rhodey flute1 => Echo echo => NRev rev => Pan2 pan1 => dac;
Rhodey flute2 => echo => rev => Pan2 pan2 => dac;
Rhodey flute3 => echo => rev => Pan2 pan3 => dac;
Rhodey flute4 => echo => rev => Pan2 pan4 => dac;
Rhodey flute5 => echo => rev => Pan2 pan5 => dac;

SinOsc SinLFO => blackhole;
TriOsc TriLFO => blackhole;
SqrOsc SqrLFO => blackhole;
PulseOsc PulseLFO => blackhole;

.1 => float masterGain;

masterGain => flute1.gain => flute2.gain => flute3.gain => flute4.gain => flute5.gain;

57 => float midiBase;

120./94. => float beatSec;
beatSec::second => dur beat;

1/beatSec *13 => SinLFO.freq;
1/beatSec *7 => TriLFO.freq;
1/beatSec *11 => SqrLFO.freq;
1/beatSec *8.1 => PulseLFO.freq;
.75 => PulseLFO.width;

7 => SqrLFO.gain;
2 => SinLFO.gain;
1 => TriLFO.gain;
1 => PulseLFO.gain;

beat - (now % beat) => now;

10::second => echo.max;
beat*1.5 => echo.delay;
.2 => echo.mix;
.5 => echo.gain;
echo => echo;

.1 => rev.mix;

now + 120::second => time future;

while (now < future) {
	
	Std.mtof( Math.round(1 + SinLFO.last() + midiBase ) ) => flute1.freq;
	1 => flute1.noteOn;
	.75*SinLFO.last() => pan1.pan;
	.125*beat => now;
	1 => flute1.noteOff;
	
	Std.mtof( Math.round( 1 + TriLFO.last() + midiBase ) )=> flute2.freq;
	1 => flute2.noteOn;
	.75*TriLFO.last() => pan2.pan;
	.125*beat => now;
	1 => flute2.noteOff;
	
	Std.mtof( Math.round(1 + SqrLFO.last() + midiBase )) => flute3.freq;
	1 => flute3.noteOn;
	.75*SqrLFO.last() => pan3.pan;
	.125*beat => now;
	1 => flute3.noteOff;
	
	Std.mtof( Math.round(1 + PulseLFO.last() + midiBase )) => flute4.freq;
	1 => flute4.noteOn;
	.75*PulseLFO.last() => pan4.pan;
	.125*beat => now;
	1 => flute4.noteOff;
	
	Std.mtof( Math.round(4 + SinLFO.last() + TriLFO.last() + SqrLFO.last() + PulseLFO.last()  + midiBase )) => flute5.freq;
	1 => flute5.noteOn;
	Std.rand2f(-.75,.75) => pan5.pan;
	.125*beat => now;
	1 => flute5.noteOff;
	1 => flute5.noteOn;
	.125*beat => now;
	1 => flute5.noteOff;
	
	.125*beat => now;
	
	if(Std.rand2f(0,1) > .5) .125::beat => now;
}

5::second => now;