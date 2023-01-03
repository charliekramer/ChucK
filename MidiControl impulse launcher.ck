250 => float gainSet;// crank for resonant filter
44-20 => float midiBase;
1 => int device;
.25::second => dur beat;//set at small frac for tones
beat => dur sporkBeat;
5::second => dur shredLength;
5::second => dur shredOutro;
2 => float Q;
.5 => float revMix;
.5 => float echoMix;
.5 => float echoGain;
0 => float sporkPan;
1 => float cutoff; //cutoff for choosing random


midiBase => float sporkBase;
Q => float sporkQ;

Impulse imp0 => BPF filt => dac;

gainSet => imp0.gain;

Std.mtof(midiBase) => filt.freq;
Q => filt.Q;


MidiIn min;
MidiMsg msg; 

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

while (true) {
    
    while( min.recv(msg) )
    {
        if (msg.data1 == 144) {
            <<< "incoming key press">>>;
            msg.data2 => sporkBase;
            <<< "incoming key press, sporkBase",sporkBase>>>;
            if (Std.rand2f(0.,1.) > cutoff) {
                spork~beatsRandom();
            }
            else {
                spork~beats(sporkBase,sporkQ,revMix,echoMix,echoGain,sporkPan,sporkBeat);
            }
        }
        
        if (msg.data1 == 176) {
            if (msg.data2 == 1) { //knob 1; pitch
                (msg.data3*3.0 + .1)/127.*midiBase => sporkBase;
                <<< "sporkBase", sporkBase >>>;
            }
            
            if (msg.data2 == 2) { //knob 2; sporkQ
                (msg.data3*20.0+127)/127*Q => sporkQ;
                <<< "sporkQ", sporkQ >>>;
            }
            
            if (msg.data2 == 3) { //knob 3; revMix
                (msg.data3*1.0)/127 => revMix;
                <<< "revMix", revMix >>>;
            }
            
            if (msg.data2 == 4) { //knob 4; echo mix
                (msg.data3*1.0)/127 => echoMix;
                <<< "echoMix", echoMix >>>;
            }
            
            
            if (msg.data2 == 5) { //knob 5; echoGain 
                msg.data3*1.0/127. => echoGain;
                <<< "echoGain", echoGain >>>;
            }
            
            
            if (msg.data2 == 6) { //knob 6; pan
                -1 + msg.data3*2.0/127. => sporkPan;
                <<< "sporkPan",sporkPan >>>;
            }
            
            
            
            if (msg.data2 == 7) { //knob 7; sporkBeat
                (.1+ msg.data3*10.0/127.)*beat => sporkBeat;
                <<< "sporkBeat ratio", (.1+ msg.data3*10.0/127.) >>>;
            }
            
            
            
            if (msg.data2 == 8) { //knob 8; randomness cutoff
                (msg.data3*1.0)/127. => cutoff;
                <<< "cutoff", cutoff >>>;
            }`
            
            
        }
        
    }

    1::ms => now;
    
    }
    

fun void beats(float sporkBase, float sporkQ, float revMix, float echoMix,
               float echoGain, float sporkPan, dur sporkBeat) {

    
     <<< "beats" >>>;

    Impulse imp0 => BPF filt => Echo echo => NRev rev =>  Dyno dyn => Pan2 pan => dac;
    
    revMix => rev.mix;
    
    sporkPan => pan.pan;
    
    gainSet*Std.rand2f(.25,1.) => imp0.gain;
    
    Std.mtof(Std.rand2f(.9,1.1)*sporkBase) => filt.freq;
    sporkQ => filt.Q;
    
    sporkBeat*Std.rand2f(.8,1.2) => dur impBeat;
    
    1.5*impBeat => echo.max => echo.delay;
    echoMix => echo.mix;
    echoGain => echo.gain;
    echo => echo;
    
    now + shredLength*Std.rand2f(.1,5.0) => time future;
    
    while (now < future) {
        
        1 => imp0.next;
        impBeat=>now;
        
    }
    
    shredOutro => now;

    
    }
    
fun void beatsRandom() {
    
        <<< "beatsRandom" >>>;
        
        Impulse imp0 => BPF filt => Echo echo => NRev rev => Pan2 pan => dac;
        
        Std.rand2f(0.,1.) => rev.mix;
        
        Std.rand2f(-1.0,1.0) => pan.pan;
        
        gainSet*Std.rand2f(.25,1.) => imp0.gain;
        
        Std.mtof(Std.rand2f(.5,2.0)*midiBase) => filt.freq;
        Std.rand2f(1.,20.)*Q => filt.Q;
        
        beat*Std.rand2f(.1,5.0) => dur impBeat;
        
        1.5*impBeat => echo.max => echo.delay;
        Std.rand2f(.1,.7) => echo.mix;
        Std.rand2f(.1,.7) => echo.gain;
        echo => echo;
        
        now + shredLength*Std.rand2f(.1,5.0) => time future;
        
        while (now < future) {
            
            1 => imp0.next;
            impBeat=>now;
            
        }
        
        
    }