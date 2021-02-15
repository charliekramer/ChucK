// supposed to work with CPE IR receiver


SerialIO.list() @=> string list[];

for(int i; i < list.size(); i++)
{
    chout <= i <= ": " <= list[i] <= IO.newline();
}

SerialIO cereal;

17 => int j; // crashes because of more than one code at a time

int a[2][j];

[[16716015, -12],
[16724175, -7],
[16726215, -5],
[16728765, -4],
[16730805, 0],
[16732845, 2],
[16734885, 4],
[16743045, 5],
[16748655, 7],
[16750695, 9],
[16753245, 11],
[16754775, 12],
[16754775, 16],
[16769055, 17],
[16769565, 19],
[4294967295, 113]] @=> int x[][]; // last one is repeat code

0 => int lastNote;

cereal.open(3, SerialIO.B9600, SerialIO.ASCII);

//0 => int i;

while (true) {
    cereal.onLine() => now;
    cereal.getLine() => string line;
    <<< "line, ", line>>>;
    Std.atoi(line) => int z;
    lookup(z,x) => int m;
    if (m == 113) lastNote => m;
    <<< "M, ", m>>>;
    spork~goNote(m);
    m => lastNote;
    
    }
    
    
fun int lookup(int key, int table[][]) {
    
    for (0 => int i; i < table.cap(); i ++) {
        if (key == table[i][0]) return table[i][1];
        }
    
    }
    
fun void goNote(int m) {
    Echo echo;
    ModalBar osc => NRev rev => Chorus chorus => dac;
    4::second => echo.max;
    .25::second => echo.delay;
    .7 => echo.mix;
    .7 => echo.gain;
    echo => echo; 
    Std.mtof(57+m) => osc.freq;
    1 => osc.noteOn;
    3::second => now;
    }
    

    