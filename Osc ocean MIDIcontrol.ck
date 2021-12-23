
.2 => float gainSet;

55 => float midiBase;

1.1 => float mUp ;
.90 => float mDown ; // min and max freq tweak

TriOsc osc[8];
Pan2 pan[8];
Echo echo[8];

2::second => dur beat;

for (0 => int i; i < osc.cap(); i++) {
    2.*i/(8-1) -1. => pan[i].pan;
    osc[i] => echo[i] => pan[i] => dac;
    beat => echo[i].max => echo[i].delay;
    .5 => echo[i].gain => echo[i].mix;
    echo[i] => echo[i];
    Std.mtof(midiBase) => osc[i].freq;
    gainSet => osc[i].gain;
}



1 => int device;

MidiIn min;
MidiMsg msg;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

while (true) {
    
    while(min.recv(msg))
    {
        if( msg.data1 == 176) //
        {
            (mDown+(mUp-mDown)*(msg.data3/127.))*Std.mtof(midiBase)+.1 => osc[msg.data2-1].freq;
            <<<"osc ",msg.data2-1, " freq, ", osc[msg.data2-1].freq() >>>;
        }
        
        
     }
     
     1::samp => now;
     
 }