.001 => float gainSet;

Impulse bass => LPF filt => Gain bassGain => Echo echo => NRev rev => Gain master => dac;

//try LPF and BPF

200 => bass.gain;

50 => filt.Q => float baseQ; // for LFO

.98 => float QLFOGain;
.3 => float QLFOFreq;

spork~LFOQ(QLFOGain, QLFOFreq);

gainSet => master.gain;

59-12 => float midiBase;


[[0., 4., 7., 9.],
 [2., 5., 9., 11.],
 [4., 7., 11., 14.],
 [5., 9., 12., 16.],
 [7., 11., 14.,17.],
 [9., 12., 16., 19.],
 [11., 14., 17., 23.],
 [12., 16., 19., 26.]]  @=> float notes[][];
  

[[0, 3, 2, 1],
 [0, 1, 2, 3],
 [0, 3, 1, 3],
 [3, 2, 1, 0],
 [2, 3, 1, 0],
 [3, 0, 1, 2],
 [2, 1, 3, 0],
 [1, 2, 3, 0]]  @=> int seq[][];
     
 
 <<< "seq size", seq.cap() >>>;
 
 60./120.*.5*2 => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

4*beat => echo.max;
1.5*beat => echo.delay;
.4 => echo.mix => float echoBaseMix;
.7 => echo.gain;
echo => echo;

.05 => rev.mix;

spork~LFOEcho(.8, .2);

int row;
     
while (true) {
    
    Std.rand2(0, seq.cap()-1) => row;
    
    for (0 => int i; i < 4; i++) {
        Std.mtof(midiBase + seq[row][i]) => filt.freq;
        100 => bass.next;
        beat => now;
    }
}
    

fun void LFOQ(float gain, float freq) {
    SinOsc QLFO => blackhole;
    gain => QLFO.gain;
    freq => QLFO.freq;
    
    while (true) {
        (1+QLFO.last())*baseQ => filt.Q;
        1::samp => now;
    }
}    
    
fun void LFOEcho(float gain, float freq) {
    SinOsc EchoLFO => blackhole;
    gain => EchoLFO.gain;
    freq => EchoLFO.freq;
    
    while (true) {
        (1+EchoLFO.last())*echoBaseMix => echo.mix;
        1::samp => now;
    }
}  
     
   
 