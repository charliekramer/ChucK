// randomized note pulses

10*.5 => float gainSet;
47 => float midiBase;

30::second => dur length;
30::second => dur outro;

.25::second => dur beat; //experiment with 2/3 beat against 3/4 beat etc
4*beat => dur pause;

1 => int minCluster; //uniform distribution for note cluster size
15 => int maxCluster;
int nCluster; // number of repetitions
1 => int cluster1Beat; // 1 to put all cluster into 1 beat

.5 => float cutoff; //cutoff value for keying envelope to echo for each of 3 echoes 
4 => float echoScale; // scale up/down echo length for all 3; 4

Rhodey osc => Gain tap => dac;

gainSet => osc.gain;
Std.mtof(midiBase) => osc.freq;

tap => Envelope env1 => Echo echo1 => NRev rev1 => dac;
tap => Envelope env2 => Echo echo2 => NRev rev2 => dac;
tap => Envelope env3 => Echo echo3 => NRev rev3 => dac;

echoScale*1.5*beat => echo1.max => echo1.delay;
.7 => echo1.gain => echo1.mix;
echo1 => echo1;

echoScale*2.25*beat => echo2.max => echo2.delay;
.7 => echo2.gain => echo2.mix;
echo2 => echo2;

echoScale*.55*beat => echo3.max => echo3.delay;
.7 => echo3.gain => echo3.mix;
echo3 => echo3;

.2 => rev1.mix => rev2.mix => rev3.mix;

now + length => time future;

while (now < future) {
    
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