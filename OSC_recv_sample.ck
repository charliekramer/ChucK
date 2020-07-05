// (launch with OSC_send.ck)

// the patch
SndBuf buf => dac;

Echo echo;

// load the file
"/Users/charleskramer/Desktop/chuck/audio/amen_break_editor.wav" => buf.read;
// don't play yet
0 => buf.play; 
1 => buf.loop;

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
            (msg.getFloat(0)-300)/100 => buf.rate;
        
        // print
        <<< "got (via OSC):", buf.rate(), msg.getFloat(0) >>>;
        // set play pointer to beginning
        1::samp => now;
        //0 => buf.pos;
    }
}
