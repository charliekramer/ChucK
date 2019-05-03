5 => int nNoise;
Noise noise[nNoise];
Envelope env[nNoise];
LPF filter[nNoise];
NRev rev[nNoise];
Pan2 pan[nNoise];
SinOsc LFO[nNoise];
ModalBar bar => NRev barRev =>  dac;
Shakers shak => NRev shakRev =>  dac;
.9 => barRev.mix;
.9 => shakRev.mix;

.2 => float masterGain;

adc => Echo echo => NRev liveRev => Gain liveGain => dac;

.7*masterGain => liveGain.gain; // set to 0 to keep out live (delayed) sound

100::second => echo.max;
10::second => echo.delay;
1 => echo.mix;
.9 => liveRev.mix;

for (0 => int i; i<nNoise; i++) {
	masterGain => noise[i].gain;
	noise[i] => env[i] => filter[i] => rev[i] => pan[i] => dac;
	5 => filter[i].Q;
	
}

1.5*masterGain => noise[0].gain;
1.2*masterGain => noise[1].gain;
0.8*masterGain => noise[2].gain;
0.6*masterGain => noise[3].gain;
0.4*masterGain => noise[4].gain;


spork~filterSweep(0, 20, 60, 0.001); 
spork~filterSweep(1, 60, 120, 0.01); 
spork~filterSweep(2, 120, 360, 0.1);
spork~filterSweep(3, 360, 880, 1);  
spork~filterSweep(4, 880, 1200, 10); 
spork~modeBar();
spork~shaker();

for (0 => int i; i<nNoise; i++) {
	1 => env[i].keyOn;
	<<< "keyOn", i >>>;
	10::second => now;
}

float runTime;

now+ 30::minute => time future;

while (now < future) {
	<<< "run" >>>;
	if (Std.rand2f(0,1) > .5 ) {
		1 => env[2].keyOn;
		Std.rand2f(.2, .9)*masterGain => noise[2].gain;
		Std.rand2f(.3,.7) => rev[2].mix;
		Std.rand2f(-.5,.5) => pan[2].pan;
		<<< "run 2">>>;
	}
	if (Std.rand2f(0,1) > .6 ) {
		1 => env[3].keyOn;
		Std.rand2f(.2, 7)*masterGain => noise[3].gain;
		Std.rand2f(.3,.7) => rev[3].mix;
		Std.rand2f(-.5,.5) => pan[3].pan;
		<<< "run 3">>>;
	}
	if (Std.rand2f(0,1) > .7 ) {
		1 => env[4].keyOn;
		Std.rand2f(.2, 5)*masterGain => noise[4].gain;
		Std.rand2f(.3,.7) => rev[4].mix;
		Std.rand2f(-.5,.5) => pan[4].pan;
		<<< "run 4">>>;
	}
	Std.rand2f(5,180) => runTime;
	<<< "runTime", runTime>>>;
	runTime::second => now;
	1=>env[2].keyOff => env[3].keyOff => env[4].keyOff;
}
	
	
for (nNoise-1 => int i; i>0; i--) {
	1 => env[i].keyOff;
	<<< "keyOff", i >>>;
	10::second => now;
}

<<< "end" >>>;
5::second => now;

now + 30::second => future;

while (now < future) {
	liveGain.gain()*.95 => liveGain.gain;
	1::ms => now;
}

fun void filterSweep(int iNoise, float minFreq, float maxFreq, float rate) {
	(maxFreq-minFreq)*.5 => float b;
	b + minFreq => float a;
	while (true) {
		a+b*LFO[iNoise].last() => filter[iNoise].freq;
	    1::samp => now;
	}
}

fun void modeBar() {
	while (true) {
		if (Std.rand2f(0,1) > .75) {
			Std.rand2(0,8) => bar.preset;
			Std.rand2f(110,440) => bar.freq;
			Std.rand2f(2,4)*masterGain => bar.gain;
			1 => bar.noteOn;
			<<< "bar" >>>;
			Std.rand2f(1,120)::second => now;
		}
	}
}

fun void shaker() {
	while (true) {
		if (Std.rand2f(0,1) > .5) {
			Std.rand2(0,16) => shak.preset;
			Std.rand2f(110,440) => shak.freq;
			Std.rand2f(2,4)*masterGain => shak.gain;
			1 => shak.noteOn;
			<<< "shak" >>>;
			Std.rand2f(1,120)::second => now;
		}
	}
}

		
	