
.4 => float gainSet;

55 => float midiBase;

2::second => dur beat;

5::minute => dur length;

3 => int maxSpork;
int nSpork;

now + length => time future;

while (now < future) {
    
    Std.rand2(1,maxSpork) => nSpork;
    for (0 => int i; i < nSpork; i++) {
        spork~ping();
    }
    Std.rand2(1,8)*.25*beat => now;   
}

10::second => now;


fun void ping() {
    
    Impulse imp => BPF filt => Echo echo => NRev rev => Dyno dyn => Pan2 pan => dac;
    2*beat => echo.max;
    gainSet => dyn.gain;
    echo.delay()*Std.rand2(1,4) => echo.delay;
    echo => echo;
    Std.rand2f(-1,1) => pan.pan;
    Std.rand2f(.2,.8) => echo.gain;
    Std.rand2f(.2,.8) => echo.mix;
    500 => imp.gain;
    Std.mtof(midiBase+Std.rand2(-1,1)*2+Std.rand2(-1,3)*12+Std.rand2(-1,1)*5) => filt.freq;
    Std.rand2f(100,200) => filt.Q;
    1 => imp.next;
    beat*4 => now;
 
    
    
}