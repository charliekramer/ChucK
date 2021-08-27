.2 => float gainSet;
1.5::second => dur beat;
30::second => dur length;
5::second => dur outro;


57 => float midiBase;

[0,5,7,-5,-7] @=> int notes[];

for (0 => int i; i < 3; i++) {

    bong(1);

}

now + length => time future;

while (now < future) {
    
    spork~bong(Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)])/Std.mtof(midiBase));
    
    beat => now;
    
}
    
for (0 => int i; i < 3; i++) {
    bong(1);
}

outro => now;

fun void bong(float shift) {
    SndBuf2 bong => Gain gain => PitShift pitch => Pan2 panL => dac;
    gain => Echo echo => ADSR env => Pan2 panR => dac;
    
    (1::ms, 1::ms, 1, 2*beat) => env.set;
    
    Std.rand2f(-1,1) => panL.pan;
    -1*panL.pan() => panR.pan;
    
    gainSet => bong.gain;
    
    1.5*beat => echo.max => echo.delay;
    1 => echo.mix;
    .7 => echo.gain;
    echo => echo;
    
    1 => pitch.mix;
    
    shift => pitch.shift;
    
    "/Users/charleskramer/Desktop/chuck/audio/dog_bowl_bongs.wav" => bong.read;
    
    Std.rand2(0,bong.samples()-1) => bong.pos;
    1 => env.keyOn;
    
    Std.rand2(1,6)*beat => now;
    1 => env.keyOff;
    2*beat => now;

    
    
}

