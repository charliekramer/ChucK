.2 => float gainSet;
11 => int nChoir;
SndBuf buf[nChoir];
ADSR env[nChoir];
PitShift pitch[nChoir];
Pan2 pan[nChoir];
NRev rev[nChoir];
Echo echo[nChoir];

Std.mtof(64)/Std.mtof(60) => float third;
Std.mtof(65)/Std.mtof(60) => float fourth;
Std.mtof(67)/Std.mtof(60) => float fifth;
Std.mtof(69)/Std.mtof(60) => float sixth;
Std.mtof(71)/Std.mtof(60) => float seventh;
Std.mtof(72)/Std.mtof(60) => float octave;

1 => int audition;

[1.] @=> float notes[];

(60./120.)::second*16 => dur beat;

"/Users/charleskramer/Desktop/chuck/audio/dc" => string name; 

-1 => pan[0].pan;

for (0 => int i; i <= buf.cap()-1; i++) {
    i+1 => int j;
    name + j => string filename;
    filename+".wav" => buf[i].read;
    buf[i].samples() => buf[i].pos;
    gainSet => buf[i].gain;
    0 => buf[i].loop;
    (2*beat,.4*beat,.9,.5*beat) => env[i].set;
    if(i > 0) pan[i-1].pan() + 2./(pan.cap()*1.-2) => pan[i].pan ;
    <<< "pan i", i, pan[i].pan()>>>;
   buf[i] => env[i] => pitch[i] => echo[i] => rev[i] => pan[i] => dac;
   .1 => rev[i].mix;
   beat*5 => echo[i].max;
   beat*.5 => echo[i].delay;
   .5 => echo[i].mix;
   .5 => echo[i].gain;
   echo[i] => echo[i];
   
   //buf[i] => env[i] => pitch[i] => echo => rev => dac;
  
}

if (audition == 1) {    
    for (0 => int i; i <= buf.cap() -1; i++) {
        1 => env[i].keyOn;
        0 => buf[i].pos;
        <<< "audition, " ,i>>>;
        beat => now;
        buf[i].samples() => buf[i].pos;
        1 => env[i].keyOff;
    }
}
now + 15::second => time future;

while (now < future) {
    for (0 => int i; i <= buf.cap()-1; i++) {
        1 => env[i].keyOn;
        0 => buf[i].pos;
        notes[Std.rand2(0,notes.cap()-1)] => pitch[i].shift;
    }
    Std.rand2f(.4,.6)*beat => now;
    for (0 => int i; i <= buf.cap()-1; i++) {
        1 => env[i].keyOff;
       }
     Std.rand2f(.4,.6)*beat => now;
}
<<< "ending dischoir" >>>;
15::second => now;



