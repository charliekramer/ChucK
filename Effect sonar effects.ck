60./94. => float beatSec;
beatSec::second => dur beat;

beat - (now% beat) => now;


BlowBotl rhodes =>  NRev r => Pan2 pan => dac;

.07 => rhodes.gain;

.5 => r.mix;

while (true){
    true =>rhodes.noteOn;
    Std.mtof(55)=>rhodes.freq;
    Std.rand2f(-1,1)=>pan.pan;
    1*beat => now;
    1=>rhodes.noteOff;
    7*beat => now;
}

