1 => float gainSet;
40::second => dur length;

Noise noise => BPF filt => ADSR env => NRev rev1 => PRCRev rev2 => Pan2 pan => dac;

gainSet => noise.gain;

20::ms => dur A;
10::ms => dur D;
1 => float S;
10::ms => dur R;

.5 => rev1.mix => rev2.mix;

250 => float baseFreq;
2 => float baseQ; //higher for pitch (20)

1.5::second => dur beat;

now + length => time future;

while (now < future) {
    
    hit(baseFreq,baseQ,A,D,S,R);   
    
}

5::second => now;


fun void hit(float freq, float Q, dur A, dur D, float S, dur R){
    
    freq*Std.rand2f(.5,2) => filt.freq;
    Q*Std.rand2f(1,5) => filt.Q;
    
    (A*Std.rand2f(.5,2),D*Std.rand2f(.5,2),S*Std.rand2f(.5,2),R*Std.rand2f(.5,2)) => env.set;
    
    Std.rand2f(-.5,.5) => pan.pan;
    
    1 => env.keyOn;
    A+D => now;
    
    1 => env.keyOff;
    R => now;
    
    Std.rand2(1,4)*.5*beat => now;
    
    }