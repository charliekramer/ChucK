// auto.ck:: sonifies itself
// charlie kramer www.northwoodselectro.com
// hmm https://opendata.stackexchange.com/questions/7042/ascii-character-frequency-analysis
// 

.5*4 => float gainSet;
.25::second => dur beat;

beat - (now % beat) => now;

BandedWG osc => Pan2 pan1 => dac;
osc => Echo echo => Pan2 pan2 => dac;

.5 => pan1.pan;
-pan1.pan() => pan2.pan;

gainSet => osc.gain;

59 => int midiBase;
//[-12,-7,-5, 0,2,5,7,9,11,14] @=> int notes[];
[0,2,4,5,7,9,11,12 ] @=> int notes[];

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
             <<< "lookup,", tableLookup(next.substring(i,1)) >>>;
             //next.charAt(i) => j;
              //playNote(j);
              playNote(tableLookup(next.substring(i,1)));
             }
     }
        
}

1::second => now;

fun void playNote(int j) {
 Std.mtof(midiBase+notes[j%notes.cap()]) => osc.freq;
 1 => osc.noteOn;
 beat => now;   
    
}

fun int tableLookup(string in) {
    
    int returnI;
    int table[13];
    
    Std.rand2(0,12) => returnI;
    
      0  => table["E"] => table["e"] => table["="] => table[";"];
      1  => table["T"] => table["t"] => table[">"];
      2  => table["A"] => table["a"] => table["+"] => table["-"];
      3  => table["A"] => table["a"] => table["*"] => table["/"];
      4  => table["O"] => table["o"];
      5  => table["I"] => table["i"];
      6  => table["N"] => table["n"];
      7  => table["S"] => table["S"];
      8  => table["R"] => table["r"];
      9  => table["H"] => table["h"];
     10  => table["D"] => table["d"];
     11  => table["L"] => table["l"];
     12  => table["U"] => table["U"];
     
     
    
      table[in] => returnI;
      
      return returnI;
      
    }

