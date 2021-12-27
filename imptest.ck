// create impulses at slightlydifferent intervals tocreate phasing

.1 => float gainSet;
30::second => dur length;

[100.,99.,101.,98.,102.,20.,200.,37.] @=> float mslist[];

for (0 => int i; i < mslist.cap(); i++) {
    spork~impfire(mslist[i]);
}

10::second => now;

fun void impfire(float mss) {
    Impulse imp => ResonZ filt => Dyno dyn => dac;
    gainSet => dyn.gain;
    1000 => imp.gain;
    220 => filt.freq;
    200 => filt.Q;

    while (true) {
        1 => imp.next;
        mss::ms => now;
    }
    
    }