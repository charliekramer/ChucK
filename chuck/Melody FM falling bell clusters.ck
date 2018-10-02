// Melody FM falling bell clusters
// ping randomly-sized clusters of bells with falling (or rising) pitch

//from Dodge and Jerse chapter 4
// basic FM synthesis using SinOsc (2 => .sync; also see fm3.ck)

Std.mtof(58) => float baseFreq; //* 1.5 interesting
5./7. => float ratio; //13./3. interesting, 1/1

4::second => dur decay;

int nBells;

while( true ) {
    Std.rand2(2,5) => nBells;
    
    for (1 => int i; i <= nBells; i++) {
       
        spork~bellStrike(baseFreq*Std.rand2f(.8,1.5));
        Std.rand2f(.25,1.1)::second => now;
    }
    <<< "n", nBells >>>;
    Std.rand2f(6.,8.)::second => now;
}


fun void bellStrike(float inFreq) {
    
    
SinOsc m => SinOsc c =>  ADSR env => PRCRev rev => Gain g => Pan2 pan => dac;

1 => g.gain;

0.3 => rev.mix;

// bell

// carrier frequency
inFreq*1.5 => c.freq; //try multiplying by 1.5, dividing by 1.5
// modulator frequency

// filter--now disabled: was ResonZ but kills volume
//c.freq()*2.5 => b.freq;
//1 => b.Q;

c.freq()*ratio => m.freq; 
// index of modulation
.2 => float imax; // max 10 lower = softer 
imax*m.freq()=> m.gain; 

// phase modulation is FM synthesis (sync is 2)
2 => c.sync;

2 => float bendSize; //as proportion of initial freq. .9 for waver, .1 for dive
4. => float bendTime; // how long bend lasts, as proportion of envelope defined above; short for vibrato

inFreq => float startFreq; //default is bend down
inFreq*bendSize => float endFreq;
float hiFreq; float lowFreq;
if (bendSize > 1.) { //if bending up
    endFreq => hiFreq;
    startFreq => lowFreq;
}
else {
    endFreq => lowFreq;
    startFreq => hiFreq;
}

           
    100 => int nStep;
    (startFreq - endFreq)/nStep => float stepSize;
    decay*bendTime => dur cycle; //  times envelope decay length
    cycle/nStep => dur stepLength;


    (0.0001::second,.00001::second,.9, decay) => env.set;
    
    1 => env.keyOn;
    
    Std.rand2f(-.25,.25) => pan.pan;
    .1::second => now;    
    1 => env.keyOff;
    
    now + 3::second => time pitchEnd;
    while (now < pitchEnd) {
        c.freq()+stepSize => c.freq;
        c.freq()*ratio => m.freq;       
        stepLength => now;
        if (c.freq() > hiFreq || c.freq() < lowFreq) -1.*=> stepSize; 
    }   
    decay+.5::second => now;
    
}


