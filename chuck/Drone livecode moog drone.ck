
0.5::second - (now% 0.5::second) => now;
.0675::second => now;

Moog  rhodes =>  NRev r => Pan2 pan => dac;
1=>r.gain;
.3=>rhodes.gain;

while (true){
    true =>rhodes.noteOn;
    50.=>rhodes.freq;
    Std.rand2f(-1,1)=>pan.pan;
    .5::second => now;
    1=>rhodes.noteOff;
    .51::second => now;
}

