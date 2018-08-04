//time synch

60/154. => float beatsec;
beatsec::second => dur beat;

beat - (now % beat) => now;

// instantiate three dim rhodes
Rhodey rhodes[3];

//sound chains
rhodes[0] => NRev rev => dac;
rhodes[1] => rev => dac;
rhodes[2] => rev => dac;

.1 => rhodes[0].gain => rhodes[1].gain => rhodes[2].gain;

0.1 => rev.mix;

[ [0,4,7], [2,3,7], [4,3,7], [5,4,7], [7,4,7], [9,3,7], [11,3,6] ] @=> int chords[][];


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
    if (i%4 == 0) rhodeschord (45,0,beattime*4);
    if (i%4 == 0) rhodeschord (45,1,beattime*4/3);
    if (i%4 == 0) rhodeschord (45,4,beattime*4/3);
    if (i%4 == 0) rhodeschord (45,5,beattime*4/3);

    
}
    