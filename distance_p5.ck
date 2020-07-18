//works with WIP_distance_changing_velocity_multicolor_sound.pde

Noise osc => LPF filt => Pan2 pan => dac;

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
oin.addAddress( "/distance/volPitchPan" );

while (true) {
    
    oin => now;
    
    while ( oin.recv(msg) != 0 )
    { 
        // getFloat fetches the expected float (as indicated by "f")
        msg.getFloat(0) => osc.gain;
        msg.getFloat(1)*hiFreq+loFreq => filt.freq;
        msg.getFloat(2) => pan.pan;
     }
    
    
   1::samp => now;
     
}