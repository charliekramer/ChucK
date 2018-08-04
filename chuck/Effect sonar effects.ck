
0.5::second - (now% 0.5::second) => now;
1::second => now;

BlowBotl rhodes =>  NRev r => Pan2 pan => dac;

.5 => rhodes.gain;

while (true){
    true =>rhodes.noteOn;
    500*1.9=>rhodes.freq;
    Std.rand2f(-1,1)=>pan.pan;
    1.5::second => now;
    1=>rhodes.noteOff;
    1.5::second => now;
}

