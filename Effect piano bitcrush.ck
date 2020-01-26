.05 => float gainSet;

SndBuf buf => blackhole;
    "/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => buf.read;
    0 => buf.pos;
    
    .05 => buf.gain;
    .5 => buf.rate;
 
Impulse imp => LPF filt => Dyno dyn => Gain master => dac;
gainSet => master.gain;

1000 => filt.freq;
2 => filt.Q;

1 => int up; //shifting flags
1 => int down; // if both zero doesn't do anything (hangs)

2 => int nShift;
1 => int nSamp;

SinOsc LFOShift => blackhole;
SinOsc LFOSamp => blackhole;

.15*.5 => LFOShift.freq;
.13*.5 => LFOSamp.freq;

1 => LFOShift.gain; // gets very loud w/o dyno for large values
1 => LFOSamp.gain; // 10 both not too crazy

now + 5::second => time future;

while (now < future) {
    Std.fabs(LFOShift.last()) $ int => nShift;
    Std.fabs(LFOSamp.last()) $ int  + 1 => nSamp;
    if (up) {  
        Std.ftoi(buf.last()*10000)<<nShift => imp.next;
        nSamp::samp => now;
    }
    if (down) {   
        Std.ftoi(buf.last()*10000)>>nShift => imp.next;
        nSamp::samp => now;
    }
    
}




 