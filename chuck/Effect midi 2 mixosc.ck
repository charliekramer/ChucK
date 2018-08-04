//MIDI

//soundchain

Rhodey p => dac;

MidiIn min;
MidiMsg msg;

// MIDI port #
1=>int port;

if (!min.open(port) )
{
    <<< "error port did not open ", port >>>;
    me.exit();
}

//global variables

int pianoNote, pianoVelocity;
Event pianoPress;

fun void playPiano()
{
    while (true)
    {
        pianoPress => now;
        Std.mtof(pianoNote) => p.freq;
        pianoVelocity/127.0 => p.noteOn;
    }
}

spork~playPiano();

while (true)
{
    min => now;
    
    while (min.recv(msg) )
    {
        <<< msg.data1,msg.data2, msg.data3>>>;
        
        if (msg.data1 == 144)
        {
            msg.data2 => pianoNote;
            msg.data3 => pianoVelocity;
            pianoPress.broadcast();
        }
        else if (msg.data1 == 128)
        {
            0 => pianoVelocity;
            pianoPress.broadcast();
        }
    }
}