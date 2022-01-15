// envelope induced tremelo
//midicontrol of beat length and ratio (on/off)

.5 => float gainSet;
60 - 24 +7+4=> float midiBase;
SinOsc osc => ADSR env => dac;

Std.mtof(midiBase) => osc.freq;
gainSet => osc.gain;

60./120. => float beatSec;

beatSec::second => dur beat;

beat => dur baseBeat;

beat - (now % beat) => now;

.5 => float ratio; // ratio of on to off

(.25*beat*ratio,.25*beat*ratio,1., .5*beat*(1-ratio)) => env.set;

MidiIn min;
MidiMsg msg; 

1 => int device;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;
 

while (true) {
    
    while( min.recv(msg) )
    {
        if (msg.data1 == 176) {
            if (msg.data2 == 1) { //knob 1; duration
                (msg.data3 + .1)/127*baseBeat => beat;
                <<< "baseBeat", baseBeat >>>;
            }
        }
    }
    
    
    1 => env.keyOn;
    .5*beat*ratio => now;
    
    1 => env.keyOff;
    .5*beat*ratio => now;
}
    
    

