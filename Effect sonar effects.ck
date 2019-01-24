60./120. => float beatSec;
beatSec::second => dur beat;

beat - (now% beat) => now;


BlowBotl rhodes =>  NRev r => Pan2 pan => dac;

.1 => rhodes.gain;

.5 => r.mix;

while (true){
    true =>rhodes.noteOn;
    Std.mtof(60-12-12)=>rhodes.freq;
    Std.rand2f(-1,1)=>pan.pan;
    1*beat => now;
    1=>rhodes.noteOff;
    7*beat => now;
}

