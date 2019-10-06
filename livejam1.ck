SinOsc sin => Echo echo => NRev rev => dac;
SawOsc saw => echo => rev => dac;

.15 => float gainSet;

gainSet => sin.gain => saw.gain;

60 => float midiBase;

Std.mtof(midiBase) => sin.freq;
Std.mtof(midiBase+7) => saw.freq;

1::second => dur beat;

beat - (now % beat) => now;

beat*5 => echo.max;
beat*1.5 => echo.delay;
.5 => echo.mix;
.3 => echo.gain;
echo => echo;

3 => float offSet;

while (true) {
	
	gainSet => sin.gain => saw.gain;
	spork~bells(sin.freq()*Std.rand2(1,8)*.5);
	Std.rand2(1,1)*.125*beat => now;
	0 => sin.gain => saw.gain;
	spork~bells(sin.freq()*Std.rand2(1,8)*.5);
	Std.rand2(1,1)*.125*beat*offSet => now;
	spork~bells(sin.freq()*Std.rand2(1,8)*.5);
	
}

fun void bells (float freq) {
	TubeBell bell => Echo bellEcho => dac;
	.5 => bell.gain;
	beat*5 => bellEcho.max;
	beat*.25 => bellEcho.delay;
	.5 => bellEcho.mix;
	.5 => bellEcho.gain;
	bellEcho => bellEcho;
	freq => bell.freq;
	1 => bell.noteOn;
	1*beat => now;
}
	
