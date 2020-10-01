
.25 => float gainSet;
10::second => dur length;

SinOsc sin => dac;

//.2  => sin.width;

gainSet => sin.gain;

10 => float min;
30 => float max;


.25::second => dur beat;

now + length => time future;

while (now < future) {
    
    Std.mtof(Std.rand2f(min,max)) => sin.freq;
    beat => now;
    
}