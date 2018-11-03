
0.5::second - (now% 0.5::second) => now;
1::second => now;

BlowBotl rhodes =>  NRev r => Pan2 pan => dac;

.1 => rhodes.gain;

while (true){
    true =>rhodes.noteOn;
    500=>rhodes.freq;
    Std.rand2f(-1,1)=>pan.pan;
    1.5::second => now;
    1=>rhodes.noteOff;
    1.5::second => now;
}

