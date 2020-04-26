// works with clocks_grid_midi processing file (if/when it works)

.1 => float gainSet;
.3 => float revSet;
2. => float filtQ;
1.5::second => dur beat;
.5 => float echoMix;
.5 => float echoGain;
3 => int n; // n^2 = number of clocks
n*n => int nn;

TriOsc osc[nn];
LPF filt[nn];
NRev rev[nn];
Echo echo[nn];
Pan2 pan[nn];

[0., 4., 7., 12., 16., 19., -12., 0., -24.] @=> float notes[];

 50. => float midiBase;

for (0 => int i; i < nn; i++) {
    osc[i] => filt[i] => echo[i] => rev[i] => pan[i] => dac;
    Std.mtof(midiBase+notes[i]) => osc[i].freq;
    -1. +  (i % n)*(n+1)/n => pan[i].pan;
    <<< "pan i", i, pan[i].pan() >>>;
    filtQ => filt[i].Q;
    gainSet => osc[i].gain;
    revSet => rev[i].mix;
    echoMix => echo[i].mix;
    echoGain => echo[i].gain;
    2*beat => echo[i].max;
    1.5*beat => echo[i].delay;
    echo[i] => echo[i];
}
  


MidiIn min;
MidiMsg msg; 

0 => int device;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;


while(true)
{
    // wait on the event 'min'
    min => now;
    
    // get the message(s)
    while( min.recv(msg) )
    {
        Std.mtof(msg.data2) => filt[channel(msg.data1)].freq;
        1::ms => now;
        
    }
    
}

fun int channel (int x) {
    return x - 144;
}