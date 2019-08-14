60./80.*.25 => float beatSec;
beatSec::second => dur beat;

beat - (now% beat) => now;

Shakers shak =>  NRev r => Pan2 pan => dac;

.5=>shak.gain;

now + .5::minute => time future;

while (now < future){
    Math.random2f(0,128) => shak.objects;
    true =>shak.noteOn;
    shak.freq;
    Std.rand2f(-1,1)=>pan.pan;
    beat*.25 => now;
    1=>shak.noteOff;
    beat*.75=> now;
}

5::second => now;
