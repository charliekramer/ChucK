60./80. => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

.1 => float gainSet;

Moog  rhodes =>  NRev r => Pan2 pan => dac;
1=>r.mix;
gainSet=>rhodes.gain;

59-24 => int midiBase;
Std.mtof(midiBase)=>rhodes.freq;

while (true){
    true =>rhodes.noteOn;
    Std.rand2f(-1,1)=>pan.pan;
    beat => now;
    1=>rhodes.noteOff;
	Std.rand2(1,2)*Std.rand2(1,2)*Std.mtof(midiBase) => rhodes.freq;// try 2 and 4 for top of distribution
    beat => now;
}

