SinOsc sin => Echo echo => NRev rev => dac;

TubeBell bell => Echo bellEcho => NRev bellRev => dac;

SinOsc LFO => blackhole;

SqrOsc LFO2 => blackhole;

SinOsc LFO3 => blackhole;

500 => LFO.freq;
25 => LFO.gain;

3 => LFO2.freq;
.4 => LFO2.gain;

.5 => LFO3.gain;
.1 => LFO3.freq;

5::second => echo.max;
.1::second => echo.delay => dur delayTime;
.5 => echo.gain;
.5  => echo.mix;
echo => echo;

5::second => bellEcho.max;
3::second => bellEcho.delay;
.5 => bellEcho.gain;
.5  => bellEcho.mix;
bellEcho => bellEcho;

[0,4,7,9,12] @=> int notes[];

0 => float gainSet => sin.gain;

1 => float gainSetBell => bell.gain;

60 - 12+7 => float midiBase;

Std.mtof(midiBase) => sin.freq => bell.freq;

while (true) {
	
	
	//Std.mtof(midiBase)*(1+LFO.last()) => sin.freq;
	//gainSet*(1+LFO2.last()) => sin.gain;
	//delayTime*(1+LFO3.last()) => echo.delay;
	if (Std.rand2f(0,1) > .9999) {
		1 => bell.noteOn;
		//Std.rand2(1,7)*.125*sin.freq() => bell.freq;
		Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => bell.freq;
		
	}
	.1::ms => now;
	
	if (Std.rand2f(0,1) > .99999) {
		<<< "pause">>>;
		0 => bell.gain;
		Std.rand2f(.1,1.5)::second => now;
		gainSetBell => bell.gain;

	}
	
	
}



