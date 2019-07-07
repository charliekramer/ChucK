// works with midi2chuck_CPE.ino
// tilt controls modalbar notes and buttons trigger saws
// light sensor controls filter cutoff
// use beat*2 => now for better rhythm but slower filter respoonse;
// need to create spork for filter control, pitch

2 => int device;

LPF filt;

ModalBar r[3] ;
r[0] => Echo echo => filt => dac;
r[1] => echo => filt => dac;
r[2] => echo => filt => dac;

 
HevyMetl saw => Envelope env => Chorus c => Echo echo2 => NRev rev => filt => dac;
.4 => saw.gain;
1 => saw.noteOn;
.3 => rev.mix;

4000 => filt.freq;
2 => filt.Q;

.1 => c.modFreq;
.3 => c.modDepth;

60./120*.5 => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

10::second => echo2.max;
beat*1.5 => echo2.delay;
.5 => echo2.gain;
.5 => echo2.mix;
echo2 => echo2;


10::second => echo.max;
beat*1.5 => echo.delay;
.3 => echo.gain;
.5 => echo.mix;
echo => echo;


MidiIn min;
MidiMsg msg;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

// infinite time-loop
0 => int j;
0 => int i;
while( j < 1000)
{
    // wait on the event 'min'
    min => now;

    // get the message(s)
    while( min.recv(msg) )
    {
        // print out midi message
///        <<< msg.data1, msg.data2, msg.data3 >>>;
    }
	j % 3 => i; 
	Std.mtof(msg.data2*.5-5*i+24*i) => r[i].freq;
	<<< msg.data2*.5-5*i+24*i >>>;
	1 => r[i].noteOn;
	if (msg.data1 == 176) {
		spork~saw_note();
	}
	if (msg.data1 == 177) {
		msg.data3*500. => filt.freq;
	}
	beat => now;
	j++;
	
}

fun void saw_note () {
	Std.mtof(26+12*msg.data3) => saw.freq;
	   <<< "saw" ,25+12*msg.data3>>>;
		1 => env.keyOn;
		2.5::second =>now;
		1 => env.keyOff;
	}

5::second => now;
