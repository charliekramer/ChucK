
.2 => float gainSet;
44+12 => float midiBase;
30::second*2 => dur length;

0 => int echoRand;
5 => int nRand;

Envelope env[8];
Echo echo[8];
LPF filt[8];
Pan2 pan[8];

.5 => float cutoff;

Wurley osc => env[0] => echo[0] => pan[0] => dac;
Std.mtof(midiBase) => osc.freq;
gainSet => osc.gain;

.5::second*2 => dur beat;

for (0 => int i; i < echo.cap()-1; i++) {
    env[i] => env[i+1] => echo[i+1] => pan[i+1] => dac;
    
}

for (0 => int i; i < echo.cap(); i++) {
    Std.rand2f(.5,4)*Std.mtof(midiBase) => filt[i].freq;
    200 => filt[i].Q;
    Std.rand2f(-1,1) => pan[i].pan;
    Std.rand2f(-1,1) => pan[i].pan;
    Std.rand2f(.1,2)*beat => env[i].duration;
    Std.rand2f(.5,1.5)*beat => echo[i].max=>echo[i].delay;
    .8 => echo[i].mix => echo[i].gain;
    echo[i] => echo[i];
}

if (echoRand == 1) {
    for (0 => int i; i <= nRand;i++) {
        echo[Std.rand2(0,echo.cap()-1)] => echo[Std.rand2(0,echo.cap()-1)];
    } 
}

now + length => time future;

while (now < future) {
    
    1 => osc.noteOn;
    
    for (0 => int i; i < echo.cap(); i++) {
        if (Std.rand2f(0,1) > cutoff) {
            1 => env[i].keyOn;
        }     
    }
    
    beat => now;
    
    for (0 => int i; i < echo.cap(); i++) {
        if (Std.rand2f(0,1) < cutoff) {
            1 => env[i].keyOff;
        }     
    }
    
    beat => now;
    
}

20*beat => now;
