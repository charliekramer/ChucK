// nixon

// soundchain for nixon 
SndBuf nixon => PitShift pitch => NRev rev => Gain g => Pan2 pan => dac;
SinOsc sin => g => dac;
0 => sin.gain;
//spork~ringmod();

.1*2 => g.gain;
0.05 => rev.mix; // turn down gain
0.9 => rev.gain; //
1.0 => pitch.mix;
1 => float pitchNixon;
1. => float rateNixon;

// synch code
60./94 => float beattime;
beattime::second => dur beat;
beat - (now % beat) => now;

//compilation
"/Users/charleskramer/Desktop/chuck/audio/nixon_compilation.wav" => nixon.read;

// compilation: sample markers

[110000,4000000,4100000,4950000,7350000] @=> int marks[];
/* 
// 0. outrageous viscious distorted reporting (6 beat)
// 1. perjury is a serious crime (4 beat)
// 2.obstruction of justice is a serious crime (8 beat)
// 3. an impeachable crime (4 beat)
// 4. i'm not a crook
*/

// farewell speech
"/Users/charleskramer/Desktop/chuck/audio/nixon_farewell.wav" => nixon.read;

// farewell: sample markers

[0,110000,250000,340000,425000] @=> marks;
/*
0. Others may hate you 4 or 8 beat
1. Those who hate you don't win 8 beat
2. Unless you hate them 4 or 8 beat
3. And then you destroy yourself 8 beat
4. You destroy yourself

*/

//cambodia_nixon


//"/Users/charleskramer/Desktop/chuck/audio/cambodia_nixon.wav" => nixon.read;

//// cambodia: sample markers

//[0,120000,250000,340000,420000] @=> marks;
/*
0. enemy activity, 2 beats
1. attacks, 2 beats
2. fear, threat, 2 beats
3. war, belligerence, 2 beats
4. credibility of the united states, # beats
*/

//"/Users/charleskramer/Desktop/chuck/audio/nixon_cancer.wav" => nixon.read;

// cancer on the presidency
// https://www.nixonlibrary.gov/sites/default/files/forresearchers/find/tapes/watergate/trial/exhibit_12.pdf

//[0,120000,250000,340000,420000] @=> marks; //good for industrial noises
//410000*23+250000 => marks[0]; // use 8 beats
/*
0. we have a cancer close to the presidency

*/
 
//"///Users/charleskramer/Desktop/chuck/audio/thp-nixon-farewell-combined.wav" => nixon.read;
//41000*55 => marks[0]; // use 16 beats
// because only if you've been in the deepest valley


//Std.ftoi( Std.rand2f(0.,nixon.samples()*1.0) ) => marks[0];
//Std.rand2(0,nixon.samples()) => marks[0];

//"/Users/charleskramer/Desktop/chuck/audio/nixon_peace.wav" => nixon.read;
//0 => marks[0];


1.0 => pan.pan;

while (true) {
    marks[0] => nixon.pos;
    rateNixon => nixon.rate;
    pitchNixon => pitch.shift;
   -1*pan.pan()=> pan.pan;
    beat*8 =>  now;  // 6; 24 for full sample of farewell
	g.gain()*.9 => g.gain; //use to fade
}

fun void ringmod() {
    3 => g.op;
    6 => sin.gain;
    while (true) {
        beat => now;
        Std.rand2f(.7,1.5)*440 => sin.freq;
    }
}


/*
// sample finder

now + 60*5::second => time finish;

0 => nixon.pos;

while (now < finish) {
   
<<< "sample position", nixon.pos() >>>;
.1::second=> now; 

}

*/

