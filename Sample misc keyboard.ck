// misc sampling keyboard
// based on saturn keyboard
//sounds of saturn
// see https://www.techtimes.com/articles/232078/20180711/saturn-sings-an-eerie-cosmic-tune-to-enceladus-here-s-how-to-listen-to-it.htm
// credit: Tom Dowling
// modify for midi control

SndBuf buf => NRev rev => Envelope e => PitShift pitch => Gain g => Pan2 p => dac;

1 => pitch.mix;

.1 => rev.mix;

0.1 => g.gain;
;

me.dir(-1)+"chuck/audio/SoundsofSaturnClip.wav" => buf.read;


15 => int sampleChoose;

if (sampleChoose == 1) 
{"/Users/charleskramer/Desktop/chuck/audio/steve_MoFo.wav" => buf.read;}
else if (sampleChoose == 2) 
{"/Users/charleskramer/Desktop/chuck/audio/wait_wilson.wav" => buf.read;}
else if (sampleChoose == 3)
{"/Users/charleskramer/Desktop/chuck/audio/lincolnshire_numberstation.wav" => buf.read;}
else if (sampleChoose == 4)
{"/Users/charleskramer/Desktop/chuck/audio/tyrolean_numberstation.wav" => buf.read;}
else if (sampleChoose == 5)
{"/Users/charleskramer/Desktop/chuck/audio/buzzer_numberstation.wav" => buf.read;}
else if (sampleChoose == 6)
{"/Users/charleskramer/Desktop/chuck/audio/pulse_sample.wav" => buf.read;}
else if (sampleChoose == 7)
{"/Users/charleskramer/Desktop/chuck/audio/voicemail-31.wav" => buf.read;}
else if (sampleChoose == 8)
{"/Users/charleskramer/Desktop/chuck/audio/delme.wav" => buf.read;}
else if (sampleChoose == 9)
{"/Users/charleskramer/Desktop/chuck/audio/nari-lata-vela.wav" => buf.read;}
else if (sampleChoose == 10)
{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesAnnouncement.wav" => buf.read;}
else if (sampleChoose == 11)
{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesBackgroundMusic.wav" => buf.read;}
else if (sampleChoose == 12)
{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesLanding.wav" => buf.read;}
else if (sampleChoose == 13)
{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesTakeoff.wav" => buf.read;}
else if (sampleChoose == 14)
{"/Users/charleskramer/Desktop/chuck/audio/Sheriff_2014-12-04.wav" => buf.read;}
else if (sampleChoose == 15)
{"/Users/charleskramer/Desktop/chuck/audio/Sigil/Sounds/spring_18cm_bowed_constantCircularStrokes.wav" => buf.read;}



MidiIn min;

1 => int port;

if (!min.open(port) )
{
    <<< "port not found ", port >>>;
    me.exit();
}

MidiMsg msg;

while (true)
{
    min => now;
    while ( min.recv(msg) ) {
        <<< msg.data1, msg.data2, msg.data3 >>>;
        if (msg.data1 == 144) {
            0=>buf.pos;
            Std.mtof(msg.data2)/Std.mtof(60)*2 => pitch.shift;
            msg.data3/127.0=>buf.gain;
            1=>e.keyOn;
            }
     }
}
