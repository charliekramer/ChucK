// (launch with OSC_send.ck)
5 => int n;
SinOsc sin[n];
// the patch
SndBuf buf => dac;

Echo echo;
.5::second => echo.max => echo.delay;
.5 => echo.mix => echo.gain;
echo => echo;
for (0 => int i; i < n; i++) {
    sin[i] => echo => dac;
}
// load the file
me.dir(-1) + "data/snare.wav" => buf.read;
// don't play yet
0 => buf.play; 

// create our OSC receiver
OscIn oin;
// create our OSC message
OscMsg msg;
// use port 6449
6448 => oin.port;
// create an address in the receiver
oin.addAddress( "/sndbuf/buf/rate" );

// infinite event loop
while ( true )
{
    // wait for event to arrive
    oin => now;

    // grab the next message from the queue. 
    while ( oin.recv(msg) != 0 )
    { 
        // getFloat fetches the expected float (as indicated by "f")
        for (0 => int i; i < n; i++) {
            msg.getFloat(i) => sin[i].freq;
        }
        // print
        <<< "got (via OSC):", buf.play() >>>;
        // set play pointer to beginning
        0 => buf.pos;
    }
}
