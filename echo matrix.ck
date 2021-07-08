// echo matrix

.2 => float gainSet;

ModalBar osc;

4 => int n;

1.5::second => dur beat;

60 => float midiBase;

Std.mtof(midiBase) => osc.freq;

Gain gain[n][n];

Echo echo[n][n];

Pan2 pan[n][n];

for (0 => int i; i < n; i++) {
    for (0 => int j; j < n; j++) {
        Std.rand2f(0,.1) => gain[i][j].gain;
        osc => echo[i][j] => pan[i][j] => dac;
        2*beat => echo[i][j].max;
        Std.rand2f(.75,1.5)*beat => echo[i][j].delay;
        .1 => echo[i][j].gain;
        .5 => echo[j][j].mix;
        (i+j)/(n)*2. - 1. => pan[i][j].pan; 
        <<< "i,j,pan", i,j,pan[i][j].pan()>>>;
        
        for (0 => int s; s < n; s++) {
            for (0 => int t; t < n; t++){
                echo[i][j] => gain[i][j] => echo[s][t];
                }
            }
        }
    }
    
while (true) {
    1 => osc.noteOn;
    2::second => now;
    
    }
    