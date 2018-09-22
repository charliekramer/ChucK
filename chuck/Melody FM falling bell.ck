// from Dodge and Jerse chapter 4
// basic FM synthesis using SinOsc (2 => .sync; also see fm3.ck)

// modulator to carrier

SinOsc m => SinOsc c => ADSR env => ResonZ b => PRCRev rev => dac;

0.2 => rev.mix;

// bell

3.5::second => dur decay;

(0.0001::second,.00001::second,.9, decay) => env.set;
// carrier frequency
400*1.5 => c.freq => float baseFreq; //try multiplying by 1.5, dividing by 1.5
// modulator frequency
c.freq()*2.5 => b.freq;
10 => b.Q;
7./5. => float ratio;
c.freq()*ratio => m.freq; 
// index of modulation
.2 => float imax; // max 10 lower = softer 
imax*m.freq()=> m.gain; 

// phase modulation is FM synthesis (sync is 2)
2 => c.sync;

// time-loop
spork~freqS(c,m);
while( true ) {
    baseFreq => c.freq;
    1 => env.keyOn;
    .1::second => now;
    1 => env.keyOff;
    6::second => now;
}

fun void freqS (SinOsc u, SinOsc v) { //u = carrier, v = mod;
   
    .1 => float bendSize; //as proportion of initial freq. .9 for waver, .1 for dive
    4. => float bendTime; // how long bend lasts, as proportion of envelope defined above; short for vibrato
  
    baseFreq => float startFreq => float hiFreq; //default is bend down
    baseFreq*bendSize => float endFreq => float lowFreq;
    if (startFreq < endFreq) { //if bending up
        endFreq => hiFreq;
        startFreq => lowFreq;
    }
        
    100 => int nStep;
    (startFreq - endFreq)/nStep => float stepSize;
    decay*bendTime => dur cycle; // 4 times envelope decay length
    cycle/nStep => dur stepLength;
 
    while (true) {  
        u.freq()+stepSize => u.freq;
        u.freq()*ratio => v.freq;       
        stepLength => now;
        if (u.freq() > hiFreq || u.freq() < lowFreq) -1.*=> stepSize; // use to create pitch cycles up/down
    }
}
