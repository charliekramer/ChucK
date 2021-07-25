.2 => float gainSet;

15::second => dur length; // length of one spork

10 => float nRun; // number of runs through (total length)

2::second => dur beat;

5 => float rateMax;

now + nRun*length => time future;

while (now < future) {
    
    Std.rand2(1,4) => int nRuns;
    
    for (1 => int i; i < nRuns; i++) {
        spork~voicemail();
    }
   
   rateMax * .75 => rateMax;
   
   4*beat => now;
    
}


8*beat => now;

fun void voicemail() {
    SndBuf buf =>  PitShift pitch => Echo echo => Envelope env => Pan2 pan => dac;    
    "/Users/charleskramer/Desktop/chuck/audio/voicemail-503.wav" => buf.read;
    1 => buf.loop;
    gainSet => buf.gain;
    Std.rand2f(-rateMax,rateMax) => buf.rate;
    
    1 => pitch.mix;
    1/Std.fabs(buf.rate()) => pitch.shift;
    
    now + length*Std.rand2f(.5,2) => time future;
    
    4*beat => echo.max;
    Std.rand2f(.1,4)*beat => echo.delay;
    Std.rand2f(.2,.7) => echo.mix;
    Std.rand2f(.2,.7) => echo.gain;
    echo => echo;
    
    Std.rand2f(-1,1) => pan.pan;
    
    1 => env.keyOn;
    
    while (now < future) {
        
        1::samp => now;
        
    }
    
    6*beat => env.duration;
    1 => env.keyOff;
    8*beat => now;
    
}
