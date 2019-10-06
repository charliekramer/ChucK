// pitch decay piano
// one note constant, one slowly decays. 

.1 => float gainSet;
61 -12 => float midiBase;
.98 => float decayFactor; // (rate of decay of second note)

120::second => dur length;

Wurley piano1 => Echo echo => NRev rev =>dac;
Wurley piano2 => echo => rev => dac;

gainSet => piano1.gain => piano2.gain;

Std.mtof(midiBase) => piano1.freq;
Std.mtof(midiBase*decayFactor) => piano2.freq;

5.0 => float noteIntervalMin; // time between note pairs (seconds)
10 => float noteIntervalMax;
.5 => float pairIntervalMin;//time within note pairs (seconds)
1.5 => float pairIntervalMax; 

.5 => rev.mix;

noteIntervalMax::second => echo.max;
(noteIntervalMin+noteIntervalMax)*.5::second => echo.delay;
.7 => echo.gain;
.7 => echo.mix;
echo => echo;

now + length => time future;

while (now < future) {
	1. - piano2.freq()/piano1.freq()*2 => rev.mix;
	1 => piano1.noteOn;
	Std.rand2f(pairIntervalMin,pairIntervalMax)::second => now;
	piano2.freq()*decayFactor => piano2.freq;
	1 => piano2.noteOn;
	Std.rand2f(noteIntervalMin,noteIntervalMax)::second => now;
	1. - piano2.freq()/piano1.freq() => rev.mix;
	
}

