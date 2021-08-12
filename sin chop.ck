.5 => float gainSet;
60::second => dur length;
10::second => dur outro;

TriOsc osc => Envelope env => Dyno dyn => Pan2 pan => dac;
dyn => Echo echo => Pan2 pan2 => dac;

gainSet => osc.gain;

.5 => pan.pan; //.25,.5
-pan.pan() => pan2.pan;

.01 => float delta; //.01

Std.mtof(57-24) => osc.freq; //(57-24)

20::ms => env.duration; // .1::ms for whoosh sound

60::second => echo.max;

env.duration()*2.1 =>  echo.delay; //*2.1
.9 => echo.mix; //.9
.9 => echo.gain;//.9
echo => echo;

now + length => time future;

while (now < future) 
{
    1 => env.keyOn;
    env.duration() => now;
    
    1 => env.keyOff;
    env.duration() => now;
    
    env.duration()*(1+delta) => env.duration;
    //env.duration()*2.1 => echo.delay;
}

outro => now;