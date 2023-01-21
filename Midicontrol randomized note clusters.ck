// randomized note pulses
// added midicontrol

1 => int device;

MidiIn min;
MidiMsg msg; 

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;


10*.5 => float gainSet;
47 => float midiBase => float midiNote;

300::second => dur length;
30::second => dur outro;

.25::second => dur beat; //experiment with 2/3 beat against 3/4 beat etc
4*beat => dur pause;

1 => int minCluster; //uniform distribution for note cluster size
15 => int maxCluster;
int nCluster; // number of repetitions
1 => int cluster1Beat; // 1 to put all cluster into 1 beat

1 => float noteTweak; // percentage tweak in note

.5 => float cutoff; //cutoff value for keying envelope to echo for each of 3 echoes 
4 => float echoScale; // scale up/down echo length for all 3; 4

.5 => float echoMix;
.7 => float echoGain;
.5 => float revMix;

Rhodey osc => Gain tap => dac;

gainSet => osc.gain;
Std.mtof(midiBase) => osc.freq;

tap => Envelope env1 => Echo echo1 => NRev rev1 => dac;
tap => Envelope env2 => Echo echo2 => NRev rev2 => dac;
tap => Envelope env3 => Echo echo3 => NRev rev3 => dac;

echoScale*1.5*beat => echo1.max => echo1.delay;
echoGain => echo1.gain;
echoMix  => echo1.mix;
echo1 => echo1;

echoScale*2.25*beat => echo2.max => echo2.delay;
echoGain => echo2.gain;
echoMix  => echo2.mix;
echo2 => echo2;

echoScale*.55*beat => echo3.max => echo3.delay;
echoGain => echo3.gain;
echoMix  => echo3.mix;
echo3 => echo3;

revMix => rev1.mix => rev2.mix => rev3.mix;

now + length => time future;

while (now < future) {
    
    while( min.recv(msg) )
    {
        if (msg.data1 == 144) {    
            midiBase+msg.data2-40 => midiNote;
            noteTweak*Std.mtof(midiNote) => osc.freq;
            <<< "new Midi note ", midiNote >>>;
           
        }
        
        if (msg.data1 == 176) {
            if (msg.data2 == 1) { //knob 1; minCluster
                Std.ftoi(msg.data3/127.0*10.) => minCluster;
                <<< "minCluster", minCluster >>>;
            }
            
            if (msg.data2 == 2) { //knob 2; maxCluster
                Std.ftoi(msg.data3/127.0*10.) => maxCluster;
                Std.ftoi(Math.max(minCluster*1.0,maxCluster*1.0)) => maxCluster;
                <<< "maxCluster", maxCluster >>>;
            }
            
            if (msg.data2 == 3) { //knob 3; noteTweak
                .5 + msg.data3/127.0*1.5 => noteTweak;
                noteTweak*Std.mtof(midiNote) => osc.freq;
                <<< "note tweak ",noteTweak >>>;
            }
            
            if (msg.data2 == 4) { //knob 4; echoGain;
                msg.data3/127.0 => echoGain;
                <<< "echoGain" , echoGain >>>;
                setEchoParameters();
            }
            
            if (msg.data2 == 5) { //knob 5; echoMix;
                msg.data3/127.0 => echoMix;
                <<< "echoMix" , echoMix >>>;
                setEchoParameters();
            }
            
            if (msg.data2 == 6) { //knob 6; revMix;
                msg.data3/127.0 => revMix;
                <<< "revMix" , revMix >>>;
                setEchoParameters();
            }
            
            if (msg.data2 == 7) { //knob 7; cutoff;
                msg.data3/127.0 => cutoff;
                <<< "cutoff", cutoff >>>;
            }
            
            if (msg.data2 == 8) { //knob 8; gain
                gainSet*msg.data3/127.0 => osc.gain;
                <<< "gain ",osc.gain() >>>;
            }
            
            
        }
        
    }
    
    
    if (minCluster == 0) {
        1 => minCluster;
    }
    
    if (maxCluster == 0) {
        minCluster => maxCluster;
    }
    
    Std.rand2(minCluster,maxCluster) => nCluster;
    
    if (Std.rand2f(0,1) < cutoff) {
        1 => env1.keyOn;
    }
    if (Std.rand2f(0,1) < cutoff) {
        1 => env2.keyOn;
    }
    if (Std.rand2f(0,1) < cutoff) {
        1 => env3.keyOn;
    }
    
    for (0 => int i; i < nCluster; i++) {
        1 => osc.noteOn;
        if (cluster1Beat == 1) {
            .5*beat / nCluster => now;
            }
        else {
            .5*beat => now;
        }
        1 => osc.noteOff;
       
        .5*beat => now;
        }
    
    1 => env1.keyOff => env2.keyOff => env3.keyOff;
    
    pause => now;
    
    }
 
outro => now;

fun void setEchoParameters() {
    echoGain => echo1.gain;
    echoMix  => echo1.mix;
    echoGain => echo2.gain;
    echoMix  => echo2.mix;
    echoGain => echo3.gain;
    echoMix  => echo3.mix;
    }