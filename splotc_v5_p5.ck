//works with splotch_v5.pde

.2 => float gainSet;

Noise osc => LPF filt => Dyno noiseDyn => Pan2 pan => dac;
Clarinet clarinet => Echo echo => NRev rev => Dyno clarinetDyn => pan => dac;

5::second => echo.max;
.75::second => echo.delay;
.7 => echo.mix;
.8 => echo.gain;
echo => echo;

.5 => rev.mix;


10 => filt.freq;
5 => filt.Q; // crank for resonant note

660 => float hiFreq; // for filter (driven by graphics)
20 => float loFreq;

// create our OSC receiver
OscIn oin;
// create our OSC message
OscMsg msg;
// use port 6449
6448 => oin.port;
// create an address in the receiver
oin.addAddress( "/splotch_v5/volPitchPan" );

while (true) {
    
    oin => now;
    
    while ( oin.recv(msg) != 0 )
    { 
        // getFloat fetches the expected float (as indicated by "f")
        msg.getFloat(0)*gainSet => osc.gain => clarinet.gain;
        msg.getFloat(1)*hiFreq+loFreq => filt.freq => clarinet.freq;
        msg.getFloat(2) => pan.pan;
        //<<< osc.gain(), filt.freq(), pan.pan() >>>;
        1 => clarinet.noteOn;
     }
    
    
   1::samp => now;
     
}