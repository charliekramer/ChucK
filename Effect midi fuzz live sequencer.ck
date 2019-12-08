class Fuzz extends Chugen
{
    1.0/2.0 => float p;
    
    2 => intensity;
    
    fun float tick(float in)
    {
        Math.sgn(in) => float sgn;
        return Math.pow(Math.fabs(in), p) * sgn;
    }
    
    fun void intensity(float i)
    {
        if(i > 1)
            1.0/i => p;
    }
}

.005 => float gainSet;

8 => int nNotes;

SinOsc s[nNotes];
LPF filt[nNotes];
Fuzz fuzz[nNotes];// or use one fuzz and chords for all for chaos
Envelope env[nNotes];// use one env for chords
Echo echo;
Gain gain;

gainSet => gain.gain;

57=> int midiBase;
[0.,2.,4.,5.,7.,9.,11.,12.] @=> float scale[];

60./120.*.5*2 => float beatSec;
beatSec::second => dur beat;

beat*5 => echo.max;
beat*1.5 => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

MidiIn min;
MidiMsg msg; 

2 => int device;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

0. => float octave;

float notes[nNotes];

for (0 => int i; i < notes.cap(); i++) {
    s[i] => fuzz[i] => filt[i] => env[i] => echo=> gain => dac;
    //s[i] => fuzz => filt[i] => dac;
    //s[i] => filt[i] => dac;
    
    midiBase => notes[i];
    Std.mtof(notes[i]+octave) => filt[i].freq;
    5 => filt[i].Q;
}

0 => int j;

while(true)
{
    // wait on the event 'min'
    //min => now;
    
    // get the message(s)
    while( min.recv(msg) )
    {
        //print out midi message
        if (msg.data1 == 144) {
        <<< msg.data1, msg.data2, msg.data3 >>>;
        midiBase+scale[msg.data2-36] => notes[j];
        }
        if (msg.data1 == 176) {
            <<< msg.data1, msg.data2, msg.data3 >>>;
            //Std.mtof(notes[j]+midiBase)*msg.data3/127.*8.+30. => filt[msg.data2-1].freq;
            Std.mtof(midiBase+scale[msg.data2-1])*msg.data3/127.*10.+30. => filt[msg.data2-1].freq;
             
             }
        
    }
    
    Std.mtof(notes[j]+octave) => s[j].freq;
    
    1 => env[j].keyOn;
    beat*.25 => now;
    1 => env[j].keyOff;
    beat*.25 => now;
    
    j++;
    if (j > notes.cap() -1) 0 => j;
    
    
    
}