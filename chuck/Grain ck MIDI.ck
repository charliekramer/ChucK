//  https://ccrma.stanford.edu/wiki/MultiGrain_Granular_Synthesis_in_Chuck
//the patch
// link to midi controller
// knobs
// 1 = duration
// 2 = position
// 3 = pitch
// 4 = randpitch (range)
// 5 = randpos (range)
// 6 = reverb
// 7 = gain
SndBuf buf2 => Envelope e => JCRev R => Gain gain => dac;

2 => gain.gain;

// load the file
"/Users/charleskramer/Desktop/chuck/audio/delme.wav" => buf2.read;
//"/Users/charleskramer/Desktop/chuck/audio/voicemail-31.wav" => buf2.read;


// number of the device to open (see: chuck --probe)
1 => int device; //changed from 0 to reflect 
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
            if( msg.data1 == 176 && msg.data2 == 1 ) //cc
            {
                msg.data3*3000/127 => duration;
                <<<duration>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 2 )
            {
                msg.data3*samples/(127) => position;
                <<<position>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 3 ) // pitch wheel
            {
                msg.data3*2.0/127 => pitch;
                <<<pitch>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 4 )
            {
                msg.data3*4.0/127 => randpitch;
                <<<randpitch>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 5 )
            {
                msg.data3*samples/127 => randompos;
                <<<randompos>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 6 )
            {
                msg.data3/127.0 => R.mix;
				<<< R.mix() >>>;
            }
			
			if( msg.data1 == 176 && msg.data2 == 7 )
			{
				msg.data3/127.0*4 => gain.gain;
				<<< gain.gain() >>>;
			}
        }
        
        Std.rand2f(pitch-randpitch,pitch+randpitch) => buf2.rate;
        Std.rand2(position-randompos,position+randompos) => buf2.pos;
        0.4 => buf2.gain;
        e.keyOn();
    	duration*0.5::ms => now;
        e.keyOff();
        50::ms => now;
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