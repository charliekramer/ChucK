// prob function from notes input
// set up to play scale

Wurley piano => dac;
1 => piano.gain;

0 => int n; // sample size
8 => int nNotes; // number of notes in the scale;
48 => float midiBase;

[0., 2., 4., 5., 7., 9.,11.,12.] @=> float scale[];
float notes[nNotes]; // total number of notes i sounded so far
float pNotes[nNotes]; // updated probability of each

for (0 => int i; i < nNotes; i++) {
    0 => notes[i];
}

.25::second => dur beat;

2 => int device;

MidiIn min;
MidiMsg msg;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

while (true) {
    while(min.recv(msg)) {
            if (msg.data1 == 144 && msg.data2 >= 36) {
                <<< " note, index#" , msg.data2, msg.data2-36 >>> ;
                notes[msg.data2-36] + 1. => notes[msg.data2-36];  
                n++;  
            }
            
            1::ms => now;
                    
     }
     
    if (n > 0) 
    {    
        
        Std.mtof(midiBase+scale[playProb()]) => piano.freq; 
        1 => piano.noteOn;
    }   
    
    beat => now;
        
    }
    
fun int playProb() {
    
    //calculate marginal probability
    
    for (0 => int i; i < nNotes; i++) {
        notes[i]/(n*1.0) => pNotes[i]; 
       // <<< "marginal i pNotes" , i, pNotes[i] >>>;
    }
    
    //convert to cumulative
    
    for (1 => int i; i < nNotes; i++) {
        pNotes[i-1] + pNotes[i] => pNotes[i]; 
    }
    
    for (0 => int i; i < nNotes; i++) {
        <<< "Pnotes i", i, pNotes[i]>>> ; 
    }
    
    
    Std.rand2f(0,1) => float z;
    int note;
    
    if (z < pNotes[0]) 0 => note;
    
    else {
        for (1 => int i; i < nNotes-1; i++) {
            if  (z> pNotes[i] && z <= pNotes[i+1]) i+1 => note; 
            }
        }
    
    <<< "z, note", z, note>>>;
    1::samp => now;
    
    return(note);
    
}