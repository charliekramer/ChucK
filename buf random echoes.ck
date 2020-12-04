.2 => float gainSet;
5 => int n;
Echo echo[n];
Pan2 pan[n];
SndBuf buf[n];
Gain gain;

20::second => dur length;

15 => float minSec;
30 => float maxSec;
45 => float pauseSec;

25 => float beatsMax;
.2 => float beatsMin;

-.2 => float minRate;
.2 => float maxRate;

1.75::second => dur beat;

for (0 => int i; i < n; i++) {
    buf[i] => gain => echo[i] => pan[i] => dac;
    0 => buf[i].pos;
    1 => buf[i].loop;    
    "/Users/charleskramer/Desktop/chuck/audio/castle_thunder.wav"=>buf[i].read;
    Std.rand2f(minRate,maxRate) => buf[i].rate;
    (beatsMax+1)*beat => echo[i].max;
    Std.rand2f(beatsMin,beatsMax)*beat => echo[i].delay;
    .6 => echo[i].mix;
    .6 => echo[i].gain;
    echo[i] => echo[i];
    Std.rand2f(-1,1) => pan[i].pan;
}
    
now + length => time future;    
    
while (now < future) {
    gainSet => gain.gain;
    Std.rand2f(minSec,maxSec)*1::second =>  now;
    0 => gain.gain;
    pauseSec*1::second => now;
    
    for (0 => int i; i < n; i++) {
        Std.rand2f(minRate,maxRate) => buf[i].rate;
        Std.rand2f(beatsMin,beatsMax)*beat => echo[i].delay;
        Std.rand2f(-1,1) => pan[i].pan;
    }
    
}
        