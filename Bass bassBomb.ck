.01*.4 => float gainSet;


SawOsc saw => Envelope env => NRev rev1 => PRCRev rev2 => ADSR adsr => Gain master => dac;
SqrOsc sqr => env => rev1 => rev2 => adsr => master => dac;
SndBuf kick => rev1 => rev2 => adsr => master => dac;

gainSet => master.gain;

"/Users/charleskramer/Desktop/chuck/audio/kick_01.wav" => kick.read;
.7 => kick.rate;
4 => kick.gain;


.1 => rev1.mix => rev2.mix;

40*4 => float baseFreq;

baseFreq*.6 => saw.freq => sqr.freq;

.5 => float prob;

60./160. => float beatSec;

beatSec::second*16*.25 => dur beat;

beat - (now % beat) => now;

.001*beat => env.duration;

(.0001*beat, .0001*beat, 1, .74*beat) => adsr.set;

while (true) {
    if (Std.rand2f(0,1) > 1-prob) {  
        spork~bassBomb(Std.rand2(1,3));
    }
    beat => now;
   
}

fun void bassBomb(int n) {
    <<< " n = ", n>>>;
    Std.rand2f(.6,.9)*baseFreq => saw.freq => sqr.freq;
    for (0 => int i; i < n; i++) {
          1 => env.keyOn;
          1 => adsr.keyOn;
          0 => kick.pos;
        .25*beat/n => now;
    }
        1 => env.keyOff;
        1 => adsr.keyOff;
        0 => kick.pos;
        .75*beat/n => now;
 
}