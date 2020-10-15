.2 => float gainSet;

SinOsc osc1 => Echo echo1 => Pan2 pan1 => dac;
SinOsc osc2 => Echo echo2 => Pan2 pan2 => dac;

.75::second => dur beat;
2*beat =>echo1.max => echo2.max;
beat => echo1.delay => echo2.delay;
.75 => echo1.mix => echo2.mix;
.75 => echo1.gain => echo2.gain;
echo1 => echo1; echo2 => echo2;


//reads from PVector_noiseines.pde

// create our OSC receiver
OscIn oin;
// create our OSC message
OscMsg msg;
// use port 6449
6448 => oin.port;
// create an address in the receiver
oin.addAddress( "/PVector_noiselines/pitchPanVol" );

// infinite event loop
while ( true )
{
    // wait for event to arrive
    oin => now;
    
    // grab the next message from the queue. 
    while ( oin.recv(msg) != 0 )
    { 
        // getFloat fetches the expected float (as indicated by "f")
        60. + 100*msg.getFloat(0) => osc1.freq; // pitch1
        60. + 100*msg.getFloat(1) => osc2.freq; // pitch2
        msg.getFloat(2) => pan1.pan; // pan1
        msg.getFloat(3) => pan2.pan; // pan2
        msg.getFloat(4)*gainSet => osc1.gain => osc2.gain; //volume
        // print
        //<<< "got (via OSC):",f0, f1, f2, f3, f4 >>>;
        // set play pointer to beginning
        1::ms => now;
    }
}
