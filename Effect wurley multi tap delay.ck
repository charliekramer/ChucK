60./94.=> float beatsec;
beatsec::second => dur beat;

beat - (now % beat) => now;

Wurley wurley => Echo echo => NRev rev => Dyno d => Pan2 p => dac; 
Echo e2 => dac;
Echo e3 => dac;

Std.mtof(55-24) => wurley.freq;
0.2 => wurley.gain;
.1 => wurley.lfoSpeed;
0.9 => wurley.lfoDepth;

0.2 => rev.mix;

10::second => echo.max => e2.max => e3.max;

beat*1.5 => echo.delay;
beat*.75 => e2.delay;
beat*1.25 => e3.delay;

0.5 => echo.mix => e2.mix => e3.mix;

echo => echo;
0.7 => echo.gain;

0.7 => e2.gain => e3.gain;

echo => e2 => e3;
echo => e3;
e2 => e2;
e3=>e3;

while (true){
1=> wurley.noteOn;
Std.rand2f(-1.,1.) => p.pan;
8*beat => now;
}