//intentional glitch
//purposely put midi out of range

.1 => float gainSet;
127 => float midiBase => float midiInit;

45::second => dur length;

.1 => float dMidiBase;

Wurley osc => PitShift pitch => LPF filt =>  Gain gain => dac;

3000 => filt.freq;
2 => filt.Q;

1 => pitch.mix;

gainSet => gain.gain;

.125::second => dur beat;

now + length => time future;

while (now < future) {
    Std.mtof(midiBase) => osc.freq;
    1 => osc.noteOn;
    beat => now;
    1 => osc.noteOff;
    beat => now;
    midiBase + dMidiBase => midiBase;
    Std.mtof(midiInit)/Std.mtof(midiBase) => pitch.shift;
}
