.1 => float gainSet;

3::minute => dur length;

Impulse imp => BPF bpfilt => LPF lpfilt => HPF hpf => NRev rev =>  Dyno dyn => Gain gain => dac;
gain => ADSR env => Echo echo => dac.left;
echo => Echo echo2 => dac.right;

gainSet => gain.gain;

.5 => rev.mix;

20 => hpf.freq;
2 => hpf.Q;

45 => float filtfreq;
2 => float filtQ;

[1.0, 1.5, 2., 3, 4., 10.0 ] @=> float freqMultiplier[];
[1.0, 10.0, 100.0, 200.0] @=> float QMultiplier[];


45 => lpfilt.freq;
200 => lpfilt.Q;

450 => bpfilt.freq;
20 => bpfilt.Q;

1::second => dur beat;
8 => int nBeats; // max number of beats per filter config

(2*beat,.1*beat,1.0, .1*beat) => env.set;

5*beat => echo.max => echo2.max;
.75* beat => echo.delay;
1.5*echo.delay() => echo2.delay;
.9 => echo.mix => echo2.mix;
.9 => echo.gain => echo2.gain;
echo => echo;
echo2 => echo2;

.5 => float cutoff; //cutoff to activate echo chain

now + length => time future;

while (now < future) {
    
    
    filtfreq*freqMultiplier[Std.rand2(0,freqMultiplier.size()-1)] => lpfilt.freq;
    filtQ*QMultiplier[Std.rand2(0,QMultiplier.size()-1)] => lpfilt.Q;
    filtfreq*freqMultiplier[Std.rand2(0,freqMultiplier.size()-1)] => bpfilt.freq;
    filtQ*QMultiplier[Std.rand2(0,QMultiplier.size()-1)]=> bpfilt.Q;
    
    <<< "lpfilt, lpQ", lpfilt.freq(), lpfilt.Q(),"bpfilt, bpQ", bpfilt.freq(), bpfilt.Q() >>>;  
    
    if (Std.rand2f(0,1) > cutoff)  {
        1 => env.keyOn;
        1./(Std.rand2(2,8))*beat => echo.delay;  
        1.5*echo.delay() => echo2.delay;
        <<< "echo on" >>>;
    }
    
    for (0 => int i; i < Std.rand2(0, nBeats); i++) {
        
        100 => imp.next;
        
        beat => now;
        
    }
    
    1 => env.keyOff;

}

10::second = > now;
