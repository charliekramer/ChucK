
   
    
    // FROM https://ccrma.stanford.edu/courses/220a-fall-2015/homework/2/hw2-ChucKFilters.pdf
    // TIME 0, start the clip
spork~clip(100::second);
 // launch clip in independent shred 10::second => now; // advance time so the clip can play
// last item in this program is this print statement

100::second => now;
<<<"program end at",now/second,"seconds">>>;
// and with nothing left to do this program exits

fun void clip(dur myDur) {
    // noise generator, resonator filter, dac (audio output)
    Noise n => ResonZ f => dac;
    // set filter Q (how sharp to make resonance)
	.1 => n.gain;
    1 => f.Q;
    // set filter gain .25 => f.gain;
    
    
    // our variable to help smoothly sweep resonant frequency
    0.0 => float t;
    //taking care of duration
    <<<"\tclip start at",now/second,"seconds">>>; now => time myBeg;
    myBeg + myDur => time myEnd;
    // timeloop
    while( now < myEnd ) {
        // sweep the filter resonant frequency
        100.0 + (1+Math.sin(t))/2 * 3000.0 => f.freq; // advance value
        t + .005 => t;
        // advance time
        5::ms => now; }
        <<<"\tclip end at",now/second,"seconds">>>; }