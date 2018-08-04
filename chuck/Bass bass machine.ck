//bass machine using modulo
//add shreds with halving dur beat for arp effects; watch gain
60./154.=> float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

SawOsc s => LPF l => Envelope e => dac;


//base frequency for bass line
110 => float baseFreq;
baseFreq => s.freq;
//frequency for alternating note
s.freq()*1.5 => float octFreq;
0.25 => s.gain;

// set up filter frequency
baseFreq*6.=>l.freq;

//envelope attack

0.00001 => e.time;

beat/2 => dur bassbeat;

for (0 => int i; true; i++) 
{
    
    
    if(i%4 ==0) {
        1=> e.keyOn;       
        baseFreq=>s.freq;
        bassbeat => now;
        1=> e.keyOff;

        
    }
    else if (i % 2 ==0) {
        1=> e.keyOn;
        octFreq=>s.freq;
        bassbeat=>now;
        1=> e.keyOff;

    }
    else {
        1=> e.keyOn;
        baseFreq/2.=>s.freq;
        bassbeat=>now;
        1=> e.keyOff;
    }
    
}