// nixon

// soundchain for nixon
SndBuf nixon => PitShift pitch => NRev rev => Gain g => Pan2 pan => dac;

1.0 => g.gain;
0.1 => rev.mix; // turn down gain
0.2 => rev.gain; //
1.0 => pitch.mix;

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
//"/Users/charleskramer/Desktop/chuck/audio/nixon_farewell.wav" => nixon.read;

// farewell: sample markers

//[0,110000,250000,340000,425000] @=> marks;
/*
0. Others may hate you 4 or 8 beat
1. Those who hate you don't win 8 beat
2. Unless you hate them 4 or 8 beat
3. And then you destroy yourself 8 beat
4. You destroy yourself

*/

1.0 => pan.pan;

while (true) {
       
    marks[0] => nixon.pos;
    1 => nixon.rate;
    1 => pitch.shift;
   -1*pan.pan()=> pan.pan;
    beat*1 =>  now;  
//	g.gain()*.9 => g.gain; use to fade
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

