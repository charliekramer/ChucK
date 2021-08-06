// auto.ck:: sonifies itself
// charlie kramer www.northwoodselectro.com
// 

.5 => float gainSet;
.25::second => dur beat;

beat - (now % beat) => now;

BandedWG osc => Pan2 pan1 => dac;
osc => Echo echo => Pan2 pan2 => dac;

.5 => pan1.pan;
-pan1.pan() => pan2.pan;

gainSet => osc.gain;

59 => int midiBase;
[-12,-7,-5, 0,2,5,7,9,11,14] @=> int notes[];

1.5*beat => echo.max => echo.delay;
1 => echo.mix;
.7 => echo.gain;
echo => echo;

FileIO fio;

"/Users/charleskramer/Desktop/chuck/auto.ck" => string filename;

fio.open( filename, FileIO.READ );

if( !fio.good() )
{
    cherr <= "can't open file: " <= filename <= " for reading..."
    <= IO.newline();
    me.exit();
}

string line;
string next;
StringTokenizer token;

int j;

while (fio.eof() == false) {
    
    
     fio.readLine() => line;
     token.set(line);
     while (token.more()) {
         token.next() => next;
         <<< "next", next >>>;
         for (0 => int i; i < next.length(); i++) {
             next.charAt(i) => j;
              playNote(j);
             }
     }
        
}

1::second => now;

fun void playNote(int note) {
 Std.mtof(midiBase+notes[j%notes.cap()]) => osc.freq;
 1 => osc.noteOn;
 beat => now;   
    
}

