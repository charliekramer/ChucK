.1 => float gainSet;

3::minute => dur length;

Wurley osc1 => LPF filt => Echo echo => dac;
Rhodey osc2 => filt => echo => dac;

5 => filt.Q;

spork~LFOfilt(.1,.5);
spork~gainLFO(.1,1.);

//[0.,3.,6.,0.,3.,7.,0.,5.,9.] @=> float notes[];
//[0.,3.,6.,0.,3.,7.,0.,5.,9.,0.,3.,11.,0.,5.,6.] @=> float notes[];

[[0.,3.,6.],[0.,3.,7.],[0.,5.,9.],[0.,3.,11.],[0.,5.,6.]] @=> float notes[][];


55 => float midiBase;

.1::second => dur beat;

beat - (now % beat) => now;

4*beat => echo.max;
Math.pow(1.5,5.)*beat => echo.delay;
.7 => echo.gain;
.7 => echo.mix;
echo => echo;

<<< "notes.cap", notes.cap()>>>;


now  + length => time future;


while (now < future) {
    
    
    
    Std.rand2(0, notes.cap()-1) => int n;
    
    for (0 => int i; i < 3; i++) {
        Std.mtof(midiBase+notes[n][i]) => osc1.freq => osc2.freq;
        1 => osc1.noteOn;
        1 => osc2.noteOn;
        //1 => osc.startBlowing;
        beat => now;
        1 => osc1.noteOff;
        1 => osc2.noteOff;
        //1 => osc.stopBlowing;
        beat => now;
    }
}

10::second => now;

fun void LFOfilt(float freq, float gain) {
    SinOsc LFO => blackhole;
    freq => LFO.freq;
    gain => LFO.gain;
    
    while (true) {
        (1+LFO.last())*Std.mtof(midiBase)*3. => filt.freq;
        1::samp => now;
    }
}

fun void gainLFO(float freq, float gain) {
    SinOsc LFO => blackhole;
    gain => LFO.gain;
    freq => LFO.freq;
    
    while (true) {
        (1.+LFO.last())*gainSet*.5 => osc1.gain;
        gainSet - osc1.gain() => osc2.gain;
        1::samp => now;
        }
}

    