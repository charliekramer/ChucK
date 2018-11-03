//time synch

60/94. => float beatsec;
beatsec::second => dur beat;

beat - (now % beat) => now;

// instantiate three dim rhodes
Rhodey rhodes[3];

//sound chains
rhodes[0] => NRev rev => dac;
rhodes[1] => rev => dac;
rhodes[2] => rev => dac;

.1 => rhodes[0].gain => rhodes[1].gain => rhodes[2].gain;

0.4 => rev.mix;

//[ [0,4,7], [2,3,7], [4,3,7], [5,4,7], [7,4,7], [9,3,7], [11,3,6] ] @=> int chords[][];


[ [0,4,7], [1,3,7], [4,5,7], [1,4,7], [7,4,7], [9,3,7], [11,3,6] ] @=> int chords[][];

//[ [0,3,6], [2,3,6], [4,3,6], [5,4,6], [7,4,6], [9,3,6], [11,3,5] ] @=> int chords[][];

fun void rhodeschord (int midinote, int numchord,dur chordtime)
{

  Std.mtof(midinote+chords[numchord][0]) => rhodes[0].freq;
  Std.mtof(midinote+chords[numchord][0]+chords[numchord][1]) => rhodes[1].freq;
  Std.mtof(midinote+chords[numchord][0]+chords[numchord][2]) => rhodes[2].freq;
  1=>rhodes[0].noteOn;
  1 => rhodes[1].noteOn; 
  1 => rhodes[2].noteOn;
  chordtime => now;
} 

//rhodeschord(40,0,1::second);

beat/2 => dur beattime;

for (0 => int i; true; i++)
{
    if (i%4 == 0) rhodeschord (58,0,beattime*4);
    if (i%4 == 0) rhodeschord (58,1,beattime*4/3);
    if (i%4 == 0) rhodeschord (58,2,beattime*4/3);
    if (i%4 == 0) rhodeschord (58,3,beattime*4/3);

    
}
    