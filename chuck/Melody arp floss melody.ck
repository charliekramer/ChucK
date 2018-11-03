// arp program
// chuck floss manual
// modified to A base note and different arp + echo and synch to 'beat'
// 
60./94 => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

58-48 => float baseFreq; // base note in MIDI (A)

SawOsc saw => LPF lowPass => ADSR adsr => Echo e => Gain g => dac;

1.5*beat => e.delay;

lowPass.Q(8);
g.gain(0.3);

[0,2,0,4,0,8,0,10] @=> int arp[]; // whole tone scale
//[0,5,0,3,9,8,0] @=> int arp[]; // array of MIDI notes 
//[0,4,0,5,0,7,12,14,16,19] @=> int arp[]; // array of MIDI notes (mod)
beat/4 => dur duration; // arpeggio rate (main loop)
adsr.set(duration*0.1, duration*0.2, 0.7, duration*0.1); // adsr parameters in accord with duration
48 => int octaveOffset;  // offset to apply to MIDI notes

//----------FUNCTIONS-----------
function void filterSweep(LPF filter, dur t){
    // generate a sweep from 100 to 10000 Hz
    100 => float cutOff;
    50 => int step;
    (9900/step)*2 => float stepNr; 
    while(true){
        filter.freq(cutOff);
        cutOff + step => cutOff;
        if(cutOff >= 10000){
            -50 => step;
        }
        else if(cutOff <= 100){
            50 => step;
        }
        t/stepNr => now; // complete a sweep (from 100 to 1000 and the way back) in "t" time
    }
}

/* create a separate thread to generate the filter 
sweep at a different rate from the main loop */
spork ~ filterSweep(lowPass, 10000::ms);

0 => int c; // arp array index

//----------MAIN-----------
while( true ){
    if( c>arp.size()-1 ){
        0 => c;
    }
    Math.random2(0,100) => int rand; // used to change the octave offset
    if(rand > 80){
        // likelihood = 20%
        60 => octaveOffset;
    }
    else{
        // likelihood = 80%
        48 => octaveOffset;
    }
    arp[c]+octaveOffset=> int note; // note from arp array + octave offset
    Std.mtof(note+baseFreq) => saw.freq;
    
    adsr.keyOn();
    duration*0.8 => now;
    
    adsr.keyOff();
    duration*0.2 => now;
    
    1 +=> c; // read next note in the arp array
}