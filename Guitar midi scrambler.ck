// based on misc sampling keyboard
// based on saturn keyboard
// dont forget to set high and low notes on input device in function

SndBuf buf => NRev rev => Envelope e => PitShift pitch => Gain g => Pan2 p => dac;

1 => pitch.mix;

.1 => rev.mix;

0.4 => g.gain;
;

me.dir(-1)+"chuck/audio/SoundsofSaturnClip.wav" => buf.read;

1 => int opt; // 1 = play full sample, pitched related to middle c
             //  2 = play segment of sample corresponding to place in the scale
			 //  3 = randomize starting place
			 //  for 2 and 3 make sure note limits on input device are set in 
			 //    returnNote function

5 => int sampleChoose;

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

1 => pitch.shift;
1 => buf.gain;

while (true)
{
    min => now;
    while ( min.recv(msg) ) {
        <<< msg.data1, msg.data2, msg.data3 >>>;
        if (msg.data1 == 144) {
			if (opt == 1) {
                0=>buf.pos;
                Std.mtof(msg.data2)/Std.mtof(60)*2 => pitch.shift;
			}
			if (opt == 2) {
				Std.ftoi(returnNote(msg.data2)) => buf.pos;
				<<< "opt 2 buf pos", buf.pos() >>>;
			}
			if (opt == 3) {
				Std.rand2(0,buf.samples()) => buf.pos;
				<<< "opt 3 buf pos", buf.pos() >>>;
			}
            msg.data3/127.0=>buf.gain;
            1=>e.keyOn;
            }
     }
}

fun float returnNote(float noteIn) {
	
	40 => int lowNote; // lowest note on standard tuned guitar
	86 => int hiNote; // highest note on standard tuned guitar w/ 22 frets
	buf.samples()/(hiNote-lowNote) => float segment; // length of each "note"
//	<<< "segment, noteIn, pct" , segment, noteIn, segment*(noteIn-lowNote)/buf.samples()>>>;
    if (noteIn > hiNote || noteIn < lowNote) <<< "noteIn", noteIn, "out of range">>> ;
	return segment*(noteIn - lowNote);
	
}

