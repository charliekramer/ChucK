
// try controlling xtime parameters with midi controller
Impulse imp => LPF filt => NRev rev => Gain gain => dac;

.1 => gain.gain;
59+12 => float midiBase;

.1 => rev.mix;

1 => int chooser;
//1 additive
//2 multiplicative

1 => float xmin; // min ms

SinOsc SinLFO =>  blackhole;
TriOsc TriLFO =>  blackhole;
SqrOsc SqrLFO =>  blackhole;
PulseOsc PulseLFO => blackhole;

// all 1s is pretty cool

1 => float SinA;
1 => float SinB;
1 => float TriA;
1 => float TriB;
1 => float SqrA;
1 => float SqrB;
1 => float PulseA;
1 => float PulseB;

.20 => SinLFO.freq; //.2
.10 => TriLFO.freq; //.1
.30 => SqrLFO.freq; //.3
.50 => PulseLFO.freq; //.5

.2 => PulseLFO.width; //.2

float xtime;

Std.mtof(midiBase) => filt.freq;
200 => filt.Q;


while (true) {
	
	if (chooser == 1) {
		Math.fabs((SinA+SinB*SinLFO.last()) + (TriA+TriB*TriLFO.last()) + (SqrA+SqrB*SqrLFO.last()) + (PulseA+PulseB*PulseLFO.last())) +xmin => xtime;
	}
	else if (chooser ==2) {
		Math.fabs((SinA+SinB*SinLFO.last()) * (TriA+TriB*TriLFO.last()) * (SqrA+SqrB*SqrLFO.last()) * (PulseA+PulseB*PulseLFO.last())) + xmin => xtime;
	}
	1 => imp.next;
	xtime::ms => now;
	
}
	
	