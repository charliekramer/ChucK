Noise noise => LPF filter => ADSR envelope => NRev rev => dac;

ModalBar bar => rev => Pan2 pan => dac;

TubeBell bell => rev => Pan2 bellPan => dac;


5 => bar.preset;

40 => float barFreq;

.2 => noise.gain;
.2 => bell.gain;

SinOsc LFO0 => blackhole;
SqrOsc LFO1 => blackhole;
TriOsc LFO2 => blackhole;
SinOsc LFO3 => blackhole;

50 => LFO1.freq => LFO2.freq => LFO0.freq;

.05 => LFO3.freq;
.05 => LFO3.gain;

360 => float baseFreq;

20 => filter.Q;

(1000::ms, 1::ms, 1, 1000::ms) => envelope.set;

now + 120::second => time future;

now + 5::second => time barTime;
barTime + 10::second => time bellTime;
bellTime + 10::second => time squareTime;



while (now < future) {
	Math.fabs(LFO0.last()+LFO1.last()+LFO2.last())*(baseFreq*(1+LFO3.last())) => filter.freq;
	1 => envelope.keyOn;
	if (now > barTime && Std.rand2f(0,1) > .995) {
		barFreq*Std.rand2f(.7,1.5) => bar.freq;
		Std.rand2f(-1,1) => pan.pan;
		1 => bar.noteOn;
		<<< "fire bar ">>>;
	}
	if (now > bellTime && Std.rand2f(0,1) > .995) {
		barFreq*Std.rand2(1,4)*4 => bell.freq;
		Std.rand2f(-1,1) => bellPan.pan;
		1 => bell.noteOn;
		<<< "fire bell ">>>;
	}
	if (now > squareTime && Std.rand2f(0,1) > .995) {
		spork~fire_square();
		<<< "fire square ">>>;
	}
	
	10::ms => now;
	1 => envelope.keyOff;
}

fire_square();

10::second => now;

fun void fire_square() {
	SqrOsc sqr => ADSR env => NRev rev => Pan2 pan => dac;
	-bellPan.pan() => pan.pan;
	.05 => sqr.gain;
	bell.freq()*.5 => sqr.freq;
	( 1::second, 1::ms, 1, 1::second ) => env.set;
	1 => env.keyOn;
	2::second => now;
	1 => env.keyOff;
	2::second => now;
}
	
