Mix2 mix;


SawOsc saw => LPF h => mix.left => Gain master => dac;
SqrOsc sin => LPF h2 => mix.right => master => dac;


.80 => sin.gain;
1.0 => saw.gain;

.1 => master.gain;

Std.mtof(60-24)*1.01 => saw.freq;
Std.mtof(60-24)*.99 => sin.freq;


saw.freq()*4=> h.freq;
3 => h.Q;
sin.freq()*12 => h2.freq;
3 => h2.Q;

SinOsc lfo => FullRect rec => blackhole; // drives mix.pan

SinOsc lfo2 => rec => blackhole; // drives LFO frequency

SinOsc lfo3 => blackhole; // drive hpf frequency on first osc

SinOsc lfo4 => blackhole; // drives sqrosc width

1. => lfo.freq;

60./120. => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

4. => float beatDiv; //4, 1, 

beatSec/beatDiv*8 => lfo2.freq;
1 => lfo2.gain;

beatSec/10.=> lfo3.freq;
1 => lfo3.gain;

beatSec/4 => lfo4.freq;

while (true) {
	lfo.last() => mix.pan;
	beat/beatDiv=> now;
	(3.5+lfo2.last())*4 => lfo.freq;
	(lfo3.last()+1.75)*4*saw.freq() => h.freq;
	1500 - h.freq() => h2.freq;
	Math.fabs(lfo4.last()/2) => sin.width;
	
}
	
	
