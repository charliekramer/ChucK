.05 => float gainSet;
.05 => float downGain; // trim gain on second patch
.5 => float downGain2; // trim gain on fourth patch
3 => float upGain; // boost on third patch

3 => int chooser;

SndBuf buf => blackhole;
SinOsc LFOm => blackhole;
SinOsc LFOd => blackhole;

.5 => LFOm.freq;
.25 => LFOd.freq;

Impulse imp => Echo echo => NRev rev => Dyno dyn => Echo echo2 => Gain gain => dac;

2::second => echo.max;
1000::samp => echo.delay; // 1000 samp for cylon sounds
.9 => echo.gain;
.9 => echo.mix;
echo => echo;

4::second => echo2.max;
Std.rand2f(.25,1.5)::second => echo2.delay;
.7 => echo2.gain;
.3 => echo2.mix;
echo2 => echo2;

gainSet => gain.gain;

30::second => dur length;


"/Users/charleskramer/Desktop/chuck/audio/secrest_poem_2.wav" => buf.read;

1 => buf.loop;

Std.rand2f(.1,3)*Math.pow(-1,Std.rand2(1,2)) => buf.rate;

now + length => time future;

40 => float m => float mBase;
20 => float d => float dBase;

spork~tweakEcho();

while (now < future) {
    
    mBase*(50+24*LFOm.last()) => m;
    dBase*(50+24*LFOm.last()) => d;
    
    if (chooser == 1) Std.ftoi((m*buf.last()) % d)/m => imp.next;
    
    
    else if (chooser == 2) {
        Std.ftoi(Std.ftoi((m*buf.last())) << Std.ftoi(d))/m => imp.next; 
        downGain*gainSet => gain.gain;
    }
    
    else if (chooser == 3) {
        (Std.ftoi(m*buf.last()) & Std.ftoi(d) )/ m=> imp.next; 
        upGain*gainSet => gain.gain; 
    }
    
    else {
        (Std.ftoi(m*buf.last()) ^ Std.ftoi(d) )/ m=> imp.next; 
        downGain2*gainSet => gain.gain; 
    }
   
    1::samp => now;  
}

25::second => now;

fun void tweakEcho() {
    
    while (true) {
        if (Std.rand2f(0,1) > .9) {
            <<< "echo trigger" >>>;
            Std.rand2f(200,3500)::samp => echo.delay;
        }
     .25::second => now;   
    }
}
