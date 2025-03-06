//receives from leapmotion via processing
//LeapMotion_Fingertips_15Inputs_v2.pde 
// this version--use more fingers

// (launch with OSC_send.ck)

// the patch

4. => float gainSet;

11 => int n;

1.75::second => dur beat;

SndBuf buf[n];
Echo echo[n];
NRev rev[n];
Pan2 pan[n];
Dyno dyn[n];


for (0 => int i; i < n; i++){
    buf[i] => echo[i] => rev[i] => dyn[i] => pan[i] => dac;
    i+1 => int j;
     "/Users/charleskramer/Desktop/chuck/audio/dc"+j+".wav" => buf[i].read;
    0 => buf[i].play; 
    1 => buf[i].loop;
    .3 => rev[i].mix;
    
    gainSet/(1.0*n) => buf[i].gain;
    
    2.*i/(n-1) -1. => pan[i].pan;
    
    beat => echo[i].max => echo[i].delay;
    .5 => echo[i].mix;
    .2 => echo[i].gain;
    echo[i] => echo[i];
    

    } 


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
        for (0 => int i; i < n; i++) {
            (msg.getFloat(i)/240.) => buf[i].rate;
            
            <<< "i, msg, rate",i, msg.getFloat(i), buf[i].rate() >>>;
        
            }
            
        // print
        // set play pointer to beginning
        1::samp => now;
        //0 => buf.pos;
    }
}
