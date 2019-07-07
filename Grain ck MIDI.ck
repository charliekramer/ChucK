//  https://ccrma.stanford.edu/wiki/MultiGrain_Granular_Synthesis_in_Chuck
//the patch
// link to midi controller
// knobs
// 1 = duration
// 2 = position
// 3 = pitch
// 4 = randpitch (range)
// 5 = randpos (range)
// 6 = reverb mix
// 7 = echo mix
// 8 = gain
SndBuf buf2 => Envelope e => Echo echo => JCRev R => Gain gain => dac;

5::second => echo.max;
1.75::second => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

8 => float baseGain;

// load the file

18 => int sampleChoose;

if (sampleChoose == 1) 
{"/Users/charleskramer/Desktop/chuck/audio/steve_MoFo.wav" => buf2.read;}
else if (sampleChoose == 2) 
{"/Users/charleskramer/Desktop/chuck/audio/wait_wilson.wav" => buf2.read;}
else if (sampleChoose == 3)
{"/Users/charleskramer/Desktop/chuck/audio/lincolnshire_numberstation.wav" => buf2.read;}
else if (sampleChoose == 4)
{"/Users/charleskramer/Desktop/chuck/audio/tyrolean_numberstation.wav" => buf2.read;}
else if (sampleChoose == 5)
{"/Users/charleskramer/Desktop/chuck/audio/buzzer_numberstation.wav" => buf2.read;}
else if (sampleChoose == 6)
{"/Users/charleskramer/Desktop/chuck/audio/pulse_sample.wav" => buf2.read;}
else if (sampleChoose == 7)
{"/Users/charleskramer/Desktop/chuck/audio/voicemail-31.wav" => buf2.read;}
else if (sampleChoose == 8)
{"/Users/charleskramer/Desktop/chuck/audio/delme.wav" => buf2.read;}
else if (sampleChoose == 9)
{"/Users/charleskramer/Desktop/chuck/audio/nari-lata-vela.wav" => buf2.read;}
else if (sampleChoose == 10)
{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesAnnouncement.wav" => buf2.read;}
else if (sampleChoose == 11)
{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesBackgroundMusic.wav" => buf2.read;}
else if (sampleChoose == 12)
{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesLanding.wav" => buf2.read;}
else if (sampleChoose == 13)
{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesTakeoff.wav" => buf2.read;}
else if (sampleChoose == 14)
{"/Users/charleskramer/Desktop/chuck/audio/Sheriff_2014-12-04.wav" => buf2.read;}
else if (sampleChoose == 15)
{"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => buf2.read;}
else if (sampleChoose == 16)
{"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano_edit.wav" => buf2.read;}
else if (sampleChoose == 17)
{"/Users/charleskramer/Desktop/chuck/audio/voicemail_goodbye.wav" => buf2.read;}
else if (sampleChoose == 18)
{"/Users/charleskramer/Desktop/chuck/audio/voicemail_unsecured_dad.wav" => buf2.read;}
else if (sampleChoose == 19)
{"/Users/charleskramer/Desktop/chuck/audio/glitchvector.wav" => buf2.read;}
else if (sampleChoose == 20)
{"/Users/charleskramer/Desktop/chuck/audio/countdown.wav" => buf2.read;}
else if (sampleChoose == 21)
{"/Users/charleskramer/Desktop/chuck/audio/mower_edit.wav" => buf2.read;}
else if (sampleChoose == 22)
{"/Users/charleskramer/Desktop/chuck/audio/cartoons.wav" => buf2.read;}



// number of the device to open (see: chuck --probe)
2 => int device; //changed from 0 to reflect 
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
                msg.data3*6000/127 => duration;
                <<<"duration, ", duration>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 2 )
            {
                msg.data3*samples/(127) => position;
                <<<"position, ",position>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 3 ) // pitch wheel
            {
                msg.data3*2.0/127 => pitch;
                <<<"pitch, ", pitch>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 4 )
            {
                msg.data3*4.0/127 => randpitch;
                <<<"randpitch, ", randpitch>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 5 )
            {
                msg.data3*samples/127 => randompos;
                <<<"randompos, ", randompos>>>;
            }
            
            if( msg.data1 == 176 && msg.data2 == 6 )
            {
                msg.data3/127.0 => R.mix;
				<<<"R.mix(), ", R.mix() >>>;
            }
			
			if( msg.data1 == 176 && msg.data2 == 7 )
			{
				msg.data3/127. => echo.mix;
				<<< "echo.mix(), ", echo.mix() >>>;
			}
			if( msg.data1 == 176 && msg.data2 == 8 )
			{
				msg.data3/127.0*baseGain => gain.gain;
				<<< "gain.gain(). " ,gain.gain() >>>;
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