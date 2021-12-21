//Time variation = -7.655 sin d + 9.873 sin(2d + 3.588)

//https://www.intmath.com/blog/mathematics/the-equation-of-time-5039

.002 => float gainSet;
20 => float midiBase;
60::second => dur length;

94. => float BPM;

(60/BPM)::second*1 => dur beat;

Impulse imp => Envelope env => Echo echo => NRev rev => Dyno dyn => dac.left;
env => echo => Echo echo2 => NRev rev2 => Dyno dyn2 => dac.right;

gainSet => imp.gain;

.5*beat => echo.max => echo.delay;
.7 => echo.mix => echo.gain;
echo => echo;
.2 => rev.mix => rev2.mix;
1.5*beat => echo2.max => echo2.delay;
.7 => echo2.mix => echo2.gain;
echo2 => echo2;


gainSet => imp.gain;

SqrOsc sin[2];

//.51 => sin[0].width;
//.44 => sin[1].width;

Std.mtof(midiBase) => sin[0].freq;
2*sin[0].freq() + 3.588  => sin[1].freq;

sin[0] => blackhole;

sin[1] => blackhole;

spork~envelope();


now +length => time future;
while (now < future) {
    -7.655*sin[0].last() + 9.873*sin[1].last() => imp.next;
    1::samp => now;
    
}

20*beat => now;

fun void envelope() {
    while (true) {
        
        1 => env.keyOn;
        Std.rand2(1,3)*beat => now;
        1 => env.keyOff;
        Std.rand2(1,3)*beat => now;
    }
    
}