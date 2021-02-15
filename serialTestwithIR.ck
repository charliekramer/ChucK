// supposed to work with CPE IR receiver
SerialIO.list() @=> string list[];

for(int i; i < list.size(); i++)
{
    chout <= i <= ": " <= list[i] <= IO.newline();
}


SerialIO cereal;

17 => int j; // crashes because of more than one code at a time

string a[2][j];
/*
16716015
16724175
16726215
16728765
16730805
16732845
16734885
16743045
16748655
16750695
16753245
16754775
16754775
16769055
16769565
4294967295
*/
cereal.open(3, SerialIO.B9600, SerialIO.ASCII);

//0 => int i;

for (0 => int i; i < j; i++) {
    cereal.onLine() => now;
    cereal.getLine() => string line;
    <<< "line", line, " i ", i>>>;
    line => a[0][i];
    }
    
for (0 => int i; i < j; i++) {
    <<< "a[0][i]", a[0][i]>>>;
    }
    