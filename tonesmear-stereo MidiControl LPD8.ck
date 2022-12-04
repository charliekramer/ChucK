.5 => float gainSet;
.7 => float revMix;
.1 => float echoLowerLimit;
2 => float echoUpperLimit; // 2; upper limit of echo distribution (*dT)
2 => float dTLowerLimit;
250 => float dTUpperLimit; //250; upper limit on dT distribution
40 => float filtLowerLimit;
2200 => float filtUpperLimit; // 1100,2200 upper limit filter freq distribution
1 => int device;
120::second => dur length;
30::second => dur outro;
2.::ms => dur dT;
0 => int mode;

["reverb mix", "echo gain", "echo mix"] @=> string modeStr[];

Impulse oscL => Echo echoL => BPF filtL => NRev revL => dac.left;

Impulse oscR => Echo echoR => BPF filtR => NRev revR => dac.right;

gainSet => oscL.gain;
gainSet => oscR.gain;

revMix => revL.mix;
revMix => revR.mix;

2::second => echoL.max => echoL.delay;
.99 => echoL.gain;
.7 => echoL.mix;
echoL => echoL;

222 => filtL.freq;
2 => filtL.Q;

2::second => echoR.max => echoR.delay;
.99 => echoR.gain;
.7 => echoR.mix;
echoR => echoR;

222 => filtR.freq;
2 => filtR.Q;

now + length => time future;

MidiIn min;
MidiMsg msg; 

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

float none;

while(now < future) {
    1 => oscL.next;
    //dTL => now;
    1 => oscR.next;
    dT => now;
    
    
    while( min.recv(msg) )
    { 
        if (msg.data1 == 176) {
            
            if (msg.data2 == 1) {
                msg.data3/127.*gainSet => oscL.gain;
                <<< "osc L gain, " , oscL.gain() >>>;
            }
            if (msg.data2 == 2) {
                map(msg.data3/127.,0.,1.,filtLowerLimit,filtUpperLimit) => filtL.freq;
                <<< "filt L freq, " , filtL.freq() >>>;
            }
            if (msg.data2 == 3) {
                map(msg.data3/127.,0.,1.,echoLowerLimit,echoUpperLimit)*dT => echoL.delay;
                <<< "echo L delay ", map(msg.data3/127.,0.,1.,echoLowerLimit,echoUpperLimit), "xdT" >>>;
            }
            if (msg.data2 == 4) {
                map(msg.data3/127.,0.,1.,dTLowerLimit,dTUpperLimit)::ms => dT;
                <<< "dT ", map(msg.data3/127.,0.,1.,dTLowerLimit,dTUpperLimit), " ms" >>>;

            }
            if (msg.data2 == 5) {
                msg.data3/127.*gainSet => oscR.gain;
                <<< "osc R gain, " , oscR.gain() >>>;
            }
            if (msg.data2 == 6) {
                map(msg.data3/127.,0.,1.,filtLowerLimit,filtUpperLimit) => filtR.freq;
                <<< "filt R freq, " , filtR.freq() >>>;
            }
            if (msg.data2 == 7) {
                 map(msg.data3/127.,0.,1.,echoLowerLimit,echoUpperLimit)*dT => echoR.delay;
                <<< "echo R delay ", map(msg.data3/127.,0.,1.,echoLowerLimit,echoUpperLimit), "xdT" >>>;
            }
            if (msg.data2 == 8) {
                
               if (mode == 0) {
                   msg.data3/127. => revL.mix => revR.mix;
                   <<< "revMix", revL.mix(), revR.mix() >>>;
               }
               
               if (mode == 1){
                   msg.data3/127.*.9999 => echoL.gain => echoR.gain;
                   <<< "echoGain", echoL.gain(), echoR.gain() >>>;
               }
               
               if (mode == 2) {
                   msg.data3/127.*.9999 => echoL.mix => echoR.mix;
                   <<< "echoMix", echoL.mix(), echoR.mix() >>>;
               }
              
            }
        }
        
        
        if (msg.data1 == 144 & msg.data2 !=39) {
            
            <<< "randomizing parameters",msg.data2,msg.data3 >>>;
            
            Std.rand2f(echoLowerLimit,echoUpperLimit)*dT => echoL.delay;
            Std.rand2f(echoLowerLimit,echoUpperLimit)*dT => echoR.delay;
            
            Std.rand2f(dTLowerLimit,dTUpperLimit)::ms => dT;
            
            Std.rand2f(.2,.99) => echoL.mix;
            Std.rand2f(.2,.99) => echoR.mix;
            
            Std.rand2f(filtLowerLimit,filtUpperLimit) => filtL.freq;
            Std.rand2f(filtLowerLimit,filtUpperLimit) => filtR.freq;
            
           
        }
        if (msg.data1 == 144 & msg.data2 ==39)
        {
            (mode + 1) % 3 => mode; //switch mode for last knob; rev, echo parameters
            <<< "mode = ", mode, modeStr[mode]>>>;
        }
    
    }
    
}
    
outro => now;

fun float map (float xin, float xmin, float xmax, float ymin, float ymax) {
    float a, b;
    (ymax - ymin)/(xmax - xmin) => b;
    ymax - b*xmax => a;
    return a + b*xin;
}