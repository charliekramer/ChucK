Noise noise => BPF f => Envelope env => Echo echo => NRev rev => Dyno dyn => dac;

3 => noise.gain;

.1 => rev.mix;

10::second => echo.max;

1.5::second => echo.delay;
.7 => echo.gain;
.5 => echo.mix;
echo => echo;


440 => f.freq;

100 => f.Q;


while (true){
	Std.rand2f(.1,3)*440.=>f.freq;
	Std.rand2f(25,50.) => f.Q;
	Std.rand2f(.25,2.5)::second => echo.delay;
	1 => env.keyOn;
	Std.rand2f(.1,.75)::second => now;
	1 => env.keyOff;
	Std.rand2f(5.,7.)::second => now;
}