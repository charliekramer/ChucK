// Melody FM falling bell clusters
// ping randomly-sized clusters of bells with falling (or rising) pitch
// this version--gentle fall in pitch and choose from pentatonic scale (no third)

//from Dodge and Jerse chapter 4
// basic FM synthesis using SinOsc (2 => .sync; also see fm3.ck)

70 => int midiBase; //base note in midi format
Std.mtof(midiBase) => float baseFreq; //* 1.5 interesting
[-24, -12, -10, -8, -5, -3,  0, 2, 4, 7, 9, 12, 24] @=> int notes[];

5./7. => float ratio; // 7./5. 13./3. interesting, 1/1

6::second => dur decay;

int nBells;
float bellFreq;

now + 10::minute => time future;

while( now < future ) {
    Std.rand2(2,3) => nBells;
    
    for (1 => int i; i <= nBells; i++) {
       	
	    Std.mtof(midiBase+notes[Std.rand2(0,notes.size()-1)]) => bellFreq;
        spork~bellStrike(bellFreq);
        Std.rand2f(1,4.2)::second => now;
		
    }
    <<< "n", nBells >>>;
    Std.rand2f(4.,8.)::second => now;
}


fun void bellStrike(float inFreq) {
    
    
SinOsc m => SinOsc c => ADSR env => PRCRev rev => Pan2 pan => Gain g => dac;

.2 => g.gain;

0.3 => rev.mix;

// bell

// carrier frequency
inFreq => c.freq; //try multiplying by 1.5, dividing by 1.5
// was for resonZ filter (kills volume)
//2.5*c.freq() => b.freq;
//10 => b.Q;

c.freq()*ratio => m.freq; 
// index of modulation
.7 => float imax; // max 10 lower = softer 
imax*m.freq()=> m.gain; 

// phase modulation is FM synthesis (sync is 2)
2 => c.sync;

.9 => float bendSize; //as proportion of initial freq. .9 for waver, .1 for dive
4 => float bendTime; // how long bend lasts, as proportion of envelope defined above; short for vibrato

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
    
    Std.rand2f(-.95,.95) => pan.pan;
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


