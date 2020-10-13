.2 => float gainSet;

SndBuf2 dnb[12];
Gain gain;

gainSet => gain.gain;

160. => float loopSpeed;
160. => float BPM;
60./BPM => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

BPM/loopSpeed => float bufRate; 

"/Users/charleskramer/Desktop/chuck/audio/dnb" => string name;
string filename;

for (0 => int i; i < dnb.cap(); i++) {
    name + (i+1) + ".wav" => dnb[i].read;
    bufRate => dnb[i].rate;
    dnb[i] => dac;
    dnb[i].samples() => dnb[i].pos;
    0 => dnb[i].loop;
    
}
/*
for (0 => int i; i < dnb.cap(); i++) {
    0 => dnb[i].pos;
    <<< "sample ",i>>>;
    16*beat => now;  
}
*/

int nBeats,nBreaks;

while (true) {
    
    1*Std.rand2(1,16) => nBeats;
    Std.rand2(1,3) => nBreaks;
    <<< "nBeats, nBreaks", nBeats, nBreaks>>>;
    spork~drumBreak(nBeats,nBreaks);
    nBeats*beat => now;
}

fun void drumBreak(int beats, int breaks){
    
    for (0 => int i; i < breaks; i++) {
        0 => dnb[Std.rand2(0,dnb.cap()-1)].pos;
    }
    
    beats*beat => now;
}


