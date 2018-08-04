// FM synthesis by hand

// carrier
SinOsc c => dac;
// modulator
SinOsc m => blackhole;

// carrier frequency
220 => float cf;
// modulator frequency
550 => float mf => m.freq;
// index of modulation
200 => float index;
0=>int i;
// time-loop
while( true )
{
    // modulate
    mf*(i % 200)/50=>m.freq;
    cf + (index * m.last()) => c.freq;
    // advance time by 1 samp
    .1::second => now;
    i++;
}
/*
// basic FM synthesis using sinosc

// modulator to carrier
SinOsc m => SinOsc c => dac;

// carrier frequency
220 => c.freq;
// modulator frequency
20 => m.freq;
// index of modulation
200 => m.gain;

// phase modulation is FM synthesis (sync is 2)
2 => c.sync;

// time-loop
while( true ) 1::second => now;
*/
/*
// actual FM using sinosc (sync is 0)
// (note: this is not quite the classic "FM synthesis"; also see fm2.ck)

// modulator to carrier
SinOsc m => SinOsc c => dac;

// carrier frequency
220 => c.freq;
// modulator frequency
20 => m.freq;
// index of modulation
200 => m.gain;

// time-loop
while( true ) 1::second => now;
*/