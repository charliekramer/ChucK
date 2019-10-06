SawOsc saw => ADSR env => LPF filter => dac;
SqrOsc sqr => env => filter => dac;

40 => float midiBase;
Std.mtof(midiBase) => saw.freq;
Std.mtof(midiBase+12) => sqr.freq;

10 => filter.Q;


ADSR filterEnv => blackhole;

60./80.*2 => float beatSec;
beatSec::second => dur beat;

(.01*beat, .25*beat, .9, .5*beat) => env.set;

(.2*beat, .06*beat, .9, .5*beat) => filterEnv.set;

1 => env.keyOn;
1 => filterEnv.keyOn;

now + .5*beat => time future;

while (now < future) {
	filterEnv.value()*saw.freq()*20. => filter.freq;
	1::ms => now;
}

1 => env.keyOff;
1 => filterEnv.keyOff;

now + .5*beat =>  future;

while (now < future) {
	filterEnv.value()*saw.freq()*20. => filter.freq;
	1::ms => now;
}
1::ms =>now;