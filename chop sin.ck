5 => int n;
.2 => float gainSet;
53 => float midiBase;
.01 => float freqDelta; // <1
.1 => float echoDelta; // < 1
60::second => dur length;

SinOsc sin[n];
Envelope env[n];
Pan2 pan[n];
Echo echo[n];
.25::second => dur beat;

for (0 => int i; i < n; i++) {
    2*beat => echo[i].max;
    .5*beat => env[i].duration;
    Std.rand2f(1-echoDelta,1+echoDelta)*1.5*beat => echo[i].delay;
    .5 => echo[i].gain;
    .5 => echo[i].mix;
    echo[i] => echo[i];
    sin[i] => env[i] => echo[i] => pan[i] => dac;
    gainSet => sin[i].gain;
    -1 + 2*(i*1. )/(n-1)*1. => pan[i].pan;
    Std.mtof(midiBase*(Std.rand2f(1-freqDelta,1+freqDelta))) => sin[i].freq;
    }
    

now + length => time future;   
while (now < future) {
        1 => env[Std.rand2(0,n-1)].keyOn;
        1 => env[Std.rand2(0,n-1)].keyOff;
        beat => now;
        }
<<< "chop sin ending "">>>;

for (0 => int i; i < n; i++) {
    1 => env[i].keyOff;
    }
    
10::second => now;