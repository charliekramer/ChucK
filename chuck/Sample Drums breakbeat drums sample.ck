// breakbeat; warp breakbeat samples preserving (or not) pitch

// soundchain for breakbeat SndBuf
SndBuf2 breakbeat => PitShift pitch[2] => dac;

// original "Amen" break is 138 bpm
138.0 => float originalBPM;
154.0 => float newBPM;
newBPM/originalBPM => breakbeat.rate;
1 => breakbeat.loop;

//pitch adjustment
1/(newBPM/originalBPM) => pitch[0].shift; //use this to preserve pitch
//1 => pitch[0].shift; //or mess with the pitch here
1.0 => pitch[0].mix;

1/(newBPM/originalBPM) => pitch[1].shift; //use this to preserve pitch
//1 => pitch[1].shift; //or mess with the pitch here
1.0 => pitch[1].mix;


// synch code
60./newBPM => float beattime;
beattime::second => dur beat;
beat - (now % beat) => now;

"/Users/charleskramer/Desktop/chuck/audio/amen_break_editor.wav" => breakbeat.read;
//"/Users/charleskramer/Desktop/chuck/audio/apache_break_editor.wav" => breakbeat.read;


while (true) {

// 0 => breakbeat.pos; // use to start the sample at the beginning
breakbeat.samples()/4 => breakbeat.pos;

4*beat => now; // 4 = one measure (shorten to build)(odd number to Crimson)

}
