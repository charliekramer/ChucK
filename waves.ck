.1 => float gainSet;
57 => float midiBase;

6::minute => dur length;

.02 => float maxSpread; // max spread for freqs;
1. => float maxPan; // max spread for pan;

4::second => dur beat;
.25 => float p;

Envelope env[4];
Echo echo[8];
Pan2 pan[8];

for (0 => int i; i < 8; i++) {
    5*beat => echo[i].max;
    1.5*beat => echo[i].delay;
    .5 => echo[i].mix;
    .5 => echo[i].gain;
    echo[i] => echo[i];
    if (i < 4) Std.rand2f(-maxPan,0) => pan[i].pan;
    else Std.rand2f(0,maxPan) => pan[i].pan;
}

for (0 => int i; i < 4; i++) { 
    gainSet => env[i].gain;
    beat*1 => env[i].duration;
}

SinOsc sinL => env[0] => echo[0] =>  pan[0] => dac;
SqrOsc sqrL => env[1] => echo[1] =>  pan[1] => dac;
TriOsc triL => env[2] => echo[2] =>  pan[2] => dac;
PulseOsc pulseL => env[3] => echo[3] =>  pan[3] => dac;

SinOsc sinR =>  env[0] =>  echo[4] =>  pan[4] => dac;
SqrOsc sqrR =>  env[1] =>  echo[5] =>  pan[5] => dac;
TriOsc triR =>  env[2] =>  echo[6] =>  pan[6] => dac;
PulseOsc pulseR =>  env[3] =>  echo[7] =>  pan[7] => dac;

now + length => time future;

while (now < future) {
    for (0 => int i; i < 4; i++) {
        if (Std.rand2f(0,1) > 1-p) {
            1 => env[i].keyOn;
        }
    }
       
            Std.mtof(midiBase + Std.rand2(-1,1)*12)*Math.pow(1.5,Std.rand2(-2,2)) => sinL.freq;
            Std.mtof(midiBase + Std.rand2(-1,1)*12)*Math.pow(1.5,Std.rand2(-2,2)) => sqrL.freq;
            Std.mtof(midiBase + Std.rand2(-1,1)*12)*Math.pow(1.5,Std.rand2(-2,2)) => triL.freq;
            Std.mtof(midiBase + Std.rand2(-1,1)*12)*Math.pow(1.5,Std.rand2(-2,2)) => pulseL.freq;
            sinL.freq()*(1.+Std.rand2f(-maxSpread,maxSpread)) => sinR.freq;
            sqrL.freq()*(1.+Std.rand2f(-maxSpread,maxSpread)) => sqrR.freq;
            triL.freq()*(1.+Std.rand2f(-maxSpread,maxSpread)) => triR.freq;
            pulseL.freq()*(1.+Std.rand2f(-maxSpread,maxSpread)) => pulseR.freq; 
    
    beat => now;
    
    for (0 => int i; i < 4; i++) {
        1 => env[i].keyOff;
    }
    
    beat => now;
}

1::minute => now;