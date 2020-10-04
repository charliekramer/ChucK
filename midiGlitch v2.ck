//intentional glitch
//purposely put midi out of range
// now with functions

.1 => float gainSet;
89 => float midiBase => float midiInit;

45::second => dur length;

.1 => float dMidiBase;

Wurley osc => Echo echo => PitShift pitch => LPF filt =>  Gain gain => dac;

3000 => filt.freq;
2 => filt.Q;

1 => pitch.mix;

gainSet => gain.gain;

.5::second => dur beat;
4*beat => echo.max;
1.5*beat => echo.delay;
.7 => echo.mix;
.7 => echo.gain;
echo => echo;

now + length => time future;

//spork~linear();
spork~LFO();

length => now;

10::second => now;

fun void linear() {
    while (now < future) {
        Std.mtof(midiBase) => osc.freq;
        1 => osc.noteOn;
        beat => now;
        1 => osc.noteOff;
        beat => now;
        midiBase + dMidiBase => midiBase;
        Std.mtof(midiInit)/Std.mtof(midiBase) => pitch.shift;
    }
}

fun void LFO() {
    0 => float j;
    SinOsc LFO => blackhole;
    .2 => LFO.freq;
    while (now < future) {
        Std.mtof(midiBase) => osc.freq;
        //<<< "osc freq", osc.freq(), "midibase", midiBase>>>;
        1 => osc.noteOn;
        beat => now;
        1 => osc.noteOff;
        beat => now;
        midiInit*(2.+ LFO.last())/4 => midiBase;
        Std.mtof(midiInit)/Std.mtof(midiBase) => pitch.shift;
       
    }
}