//https://ccrma.stanford.edu/wiki/MultiGrain_Granular_Synthesis_in_Chuck
// the patch
SndBuf buf2 => Envelope e => JCRev R => dac;

// load the file
"/Users/charleskramer/Desktop/chuck/audio/chiko.wav" => buf2.read;


// number of the device to open (see: chuck --probe)
2 => int device;
// get command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// the midi event
MidiIn min;
// the message for retrieving data
MidiMsg msg;

// open the device
if( !min.open( device ) ) me.exit();

// print out device that was opened
<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

fun void grain(float duration , int position, float pitch, int randompos, float randpitch)
{ 
    int samples;
    buf2.samples() => samples;
    44100*position/1000 => position;
    44100*randompos/1000 => randompos;
    
    // can be changed to acheive a more varying
    // asynchronous envelope for each grain duration
    duration*Std.rand2f(0.45,0.5)::ms => e.duration;
    float freq;
    while( true )
    {   
        while(min.recv(msg))
        {
            if( msg.data1 == 176 && msg.data2 == 74 )
            {
                msg.data3*150/127 => duration;
                <<<duration>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 71 )
            {
                msg.data3*samples/(127) => position;
                <<<position>>>;
            }
            
            if( msg.data1 == 224 )
            {
                msg.data3*2.0/127 => pitch;
                <<<pitch>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 1 )
            {
                msg.data3*4.0/127 => randpitch;
                <<<randpitch>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 73 )
            {
                msg.data3*samples/127 => randompos;
                <<<randompos>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 72 )
            {
                msg.data3/127.0 => R.mix;
            }
        }
        
        Std.rand2f(pitch-randpitch,pitch+randpitch) => buf2.rate;
        Std.rand2(position-randompos,position+randompos) => buf2.pos;
        0.4 => buf2.gain;
        e.keyOn();
        duration*0.5::ms => now;
        e.keyOff();
        duration*0.5::ms => now;
    }
}

0 => R.mix;

80 => float grain_duration; 
1020 => int position; 
1.0 => float base_pitch;
0 => int rand_position;
0.0 => float rand_pitch;

spork ~ grain(grain_duration,position,base_pitch,rand_position,rand_pitch);

// time loop
while( true )
{
    1::ms => now;
}