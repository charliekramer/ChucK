// https://science.sciencemag.org/content/243/4889/311

.1 => float gainSet;

Clarinet osc => Echo echo => dac;

gainSet => osc.gain;

.7 => float n;
3.5 => float a0;
float a;
SinOsc LFO => blackhole;

.1 => LFO.freq;
.2 => LFO.gain;

SinOsc LFOEcho => blackhole;
.02 => LFOEcho.freq;
1*0 => LFOEcho.gain;
SqrOsc LFOEchoSquare => blackhole;
.35 => LFOEchoSquare.freq;
.5*0 => LFOEchoSquare.gain;

300 => float minSample;
4000 => float maxSample;
300 => float nSample;

2::second => echo.max;
4000::samp => echo.delay; //100::samp makes weird feedback with high echo gain
.9 => echo.mix;
.99 => echo.gain;
echo => echo;
int index;

51-24 => float midiBase;
[0.,1.,4.,5.,6.,7.,8,11.,12.] @=> float notes[];


while (n > 0.0001) {
    
    a0 + LFO.last() => a;
    
    a*(n - Math.pow(n,2)) => n;
    //<<< "a ", a, "n " , n>>>;
    Std.ftoi(n*notes.cap() ) => index;
    if (index == 9) 8 => index;
    Std.mtof(notes[index]) => osc.freq;
    1 => osc.noteOn;
    .001::second => now;
    
    (minSample + (1+LFOEcho.last())*.5*(maxSample-minSample))*Std.rand2f(.999,1.001)*(1+LFOEchoSquare.last()) => nSample;
    nSample::samp => echo.delay;
    
    
}