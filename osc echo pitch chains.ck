// set up to play from keyboard
// # keys do on/off
// space bar resets
.05 => float gainSet;
57-12-12-2-2-2-2 -2 => float midiBase;
Echo echo[4];
PitShift pitch[4];
Pan2 pan[4];
Envelope env[4];

SawOsc saw => env[0] => pitch[0] => echo[0] => pan[0] => dac;
TriOsc tri => env[1] => pitch[0] => pitch[1] => echo[0] => echo[1] => pan[1] => dac;
SqrOsc sqr => env[2] => pitch[0] => pitch[1] => pitch[2] => echo[0] => echo[1] => echo[2] => pan[2] => dac;
PulseOsc pulse => env[3] => pitch[0] => pitch[1] => pitch[2] => pitch[3] => echo[0] => echo[1] => echo[2] => echo[3] => pan[3] => dac;

.25 => pulse.width;

gainSet => saw.gain => tri.gain => sqr.gain => pulse.gain;
Std.mtof(midiBase) => saw.freq => tri.freq => sqr.freq => pulse.freq;

SinOsc LFOs[4];

for (0 => int i; i < LFOs.cap(); i++) {
    LFOs[i] => blackhole;
    Std.rand2f(.1,.105*1) => LFOs[i].freq;
    Std.rand2f(.01,.0105*1) => LFOs[i].gain;
}

.25::second*16 => dur beat;

for (0 => int i; i < echo.cap(); i++) {
    4*beat => echo[i].max;
    Std.rand2f(.1,3.5)*beat => echo[i].delay;
    Std.rand2f(.2,.7) => echo[i].gain;
    Std.rand2f(.2,.7) => echo[i].mix;
    echo[i] => echo[i];
    1 => pitch[i].mix;
    Std.rand2f(-1,1) => pan[i].pan;
}

spork~pitchLFO();

for (0 => int i; i < 4; i++) {
    <<< "i",i>>>;
    1 => env[i].keyOn;
    2::second => now;
    1 => env[i].keyOff;
    2::second => now;
}
    
for (0 => int i; i < 4; i++) {
        <<< "i",i>>>;
        1 => env[i].keyOn;
}

10::second => now;

for (0 => int i; i < 4; i++) {
    <<< "i",i>>>;
    1 => env[i].keyOff;
}

10::second => now;



fun void pitchLFO() {
    while (true) {
        for (0 => int i; i < pitch.cap(); i++) {
            (1+LFOs[i].last()) => pitch[i].shift;  
        } 
     1::samp => now;   
    }
}

    