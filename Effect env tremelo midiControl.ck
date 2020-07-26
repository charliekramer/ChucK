// envelope induced tremelo
//midicontrol of beat length and ratio (on/off)

.5 => float gainSet;

60 - 24 +7+4=> float midiBase;


[0.,2.,4.,5.,7.,9.,11.,12.] @=> float notes[];

PulseOsc osc => ADSR env => Gain gain => dac;

gain => Echo echoL => dac.left;
gain => Echo echoR => dac.right;

Std.mtof(midiBase) => osc.freq;
gainSet => osc.gain;
0 => osc.gain;

60./120. => float beatSec;

beatSec::second => dur beat;

4*beat => echoL.max => echoR.max;
1.5*beat => echoL.delay;
.75*echoL.delay() => echoR.delay;
.5 => echoL.gain => echoR.gain;
1 => echoL.mix => echoR.mix;
echoL => echoL;
echoR => echoR;



beat => dur baseBeat;

beat - (now % beat) => now;

.5 => float ratio; // ratio of on to off

1 => float echoLRatio; //ratio of echo length to beat;
1 => float echoRRatio; 

(.25*beat*ratio,.25*beat*ratio,1., .5*beat*(1-ratio)) => env.set;

MidiIn min;
MidiMsg msg; 

2 => int device;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;
 

while (true) {
    
    while( min.recv(msg) )
    {
        if (msg.data1 == 144) {
            Std.mtof(midiBase+notes[msg.data2 - 36]) => osc.freq;
            <<< "osc freq", osc.freq() >>>;
        }
        if (msg.data1 == 176) {
            if (msg.data2 == 1) { //knob 1; duration
                (msg.data3*1.0 + .1)/127.*baseBeat => beat;
                <<< "baseBeat", baseBeat >>>;
            }
            if (msg.data2 == 2) { //knob 2; ratio
                (msg.data3*1.0)/127 => ratio;
                <<< "ratio", ratio >>>;
            }
            if (msg.data2 == 3) { //knob 3; echoL mix
                (msg.data3*1.0)/127 => echoL.mix;
                <<< "echoL.mix", echoL.mix() >>>;
            }
            if (msg.data2 == 4) { //knob 4; echoR gain
                (msg.data3*1.0)/127 => echoR.mix;
                <<< "echoR.mix", echoR.mix() >>>;
            }
            
            if (msg.data2 == 5) { //knob 5; echoL ratio
                msg.data3*3.0/127. => echoLRatio;
                <<< "echoLRatio", echoLRatio >>>;
            }
            if (msg.data2 == 6) { //knob 6; echoR ratio
                msg.data3*3.0/127. => echoRRatio;
                <<< "echoRRatio", echoRRatio >>>;
            }
            
            if (msg.data2 == 7) { //knob 7; osc width
                msg.data3*1.0/127. => osc.width;
                <<< "osc width", osc.width() >>>;
            }
            
            if (msg.data2 == 8) { //knob 8; osc gain
                (msg.data3*1.0)/127*4*gainSet => osc.gain;
                <<< "osc gain", osc.gain() >>>;
            }
        }
    }
    
    
    beat*echoLRatio => echoL.delay;
    beat*echoRRatio => echoR.delay;
        
    1 => env.keyOn;
    .5*beat*ratio => now;
    
    1 => env.keyOff;
    .5*beat*(1-ratio) => now;
}
    
    

