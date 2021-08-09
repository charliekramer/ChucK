

.01 => float gainSet;
25 => int n; // max 100, lower number => more wobble

1.5::second => dur beat; //1.5 sec
2::minute => dur length; 

SinOsc osc[n];
Envelope env[n];
Pan2 pan[n];

.01 => float delta => float deltaBase; //.1, .01 for ripple
57-12-12=> float midiBase; //57-24

//spork~LFODelta(); //eats a lot of bandwidth

for (0 => int i; i < n; i++) {
    Std.mtof(midiBase)*Math.pow(1+delta,i) => osc[i].freq;
    gainSet => osc[i].gain;
    osc[i] => env[i] => pan[i] => dac;
    Std.rand2f(-1.,1) => pan[i].pan;
    beat => env[i].duration;
    }
    
    
now + length => time future;
    
while (now < future) {
    for (0 => int i; i < n; i++) {
        Std.rand2(0,1) => env[i].keyOn;
        }
    4*beat => now;
    for (0 => int i; i < n; i++) {
        Std.rand2(0,1) => env[i].keyOff;
    }
    beat => now;
    
    
    }
    
for (0 => int i; i < n; i++) {
        8*beat => env[i].duration;
        1 => env[i].keyOn;
    }
    
8*beat => now;
    
for (0 => int i; i < n; i++) {
        8*beat => env[i].duration;
        1 => env[i].keyOff;
    }
    
8*beat => now;

    
fun float LFODelta() {
    SinOsc LFO => blackhole;
    .04 => LFO.freq;
    
    while (true) {
        (1+.05*LFO.last())*deltaBase => delta;
        for (0 => int i; i < n; i++) {
            Std.mtof(midiBase)*Math.pow(1+delta,i) => osc[i].freq;
        }
        1::samp => now;
        }
        

        
}