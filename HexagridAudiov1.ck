// (launch with OSC_send.ck)
SawOsc osc0 => Gain gain0 => Echo echo0 => Pan2 pan0 => dac;
SinOsc osc1 => Gain gain1 => Echo echo1 => Pan2 pan1 => dac;
TriOsc osc2 => Gain gain2 => Echo echo2 => Pan2 pan2 => dac;
SqrOsc osc3 => Gain gain3 => Echo echo3 => Pan2 pan3 => dac;

2 => float gainSet;

220 => float baseFreq;
baseFreq => osc0.freq;
baseFreq*1.5 => osc1.freq;
baseFreq*1.5*1.5 => osc2.freq;
baseFreq/1.5 => osc3.freq;

.5*gainSet => gain0.gain; //NW
2*gainSet => gain1.gain; //NE
2*gainSet => gain2.gain; //SW
1*gainSet => gain3.gain; //SE


// the patch

-1 => pan0.pan;
1 => pan1.pan;
-1 => pan2.pan;
1 => pan3.pan;

.55::second => echo0.max => echo0.delay;
.5 => echo0.mix => echo0.gain;
echo0 => echo0;
.5::second => echo1.max => echo1.delay;
.5 => echo1.mix => echo1.gain;
echo1 => echo1;
.45::second => echo2.max => echo2.delay;
.5 => echo2.mix => echo2.gain;
echo2 => echo2;
.65::second => echo3.max => echo3.delay;
.5 => echo3.mix => echo3.gain;
echo3 => echo3;
// load the file
// don't play yet

// create our OSC receiver
OscIn oin;
// create our OSC message
OscMsg msg;
// use port 6449
6448 => oin.port;
// create an address in the receiver
oin.addAddress( "/hexagrid/avBright" );

// infinite event loop
while ( true )
{
    // wait for event to arrive
    oin => now;

    // grab the next message from the queue. 
    while ( oin.recv(msg) != 0 )
    { 
        // getFloat fetches the expected float (as indicated by "f")
            msg.getFloat(0)/125. => osc0.gain;
            msg.getFloat(1)/125. => osc1.gain;
            msg.getFloat(2)/125. => osc2.gain;
            msg.getFloat(3)/125. => osc3.gain;
        // print
        <<< "got (via OSC):", msg.getFloat(0), msg.getFloat(1), msg.getFloat(2), msg.getFloat(3) >>>;
        // set play pointer to beginning
       }
}
