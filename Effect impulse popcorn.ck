Impulse imp => LPF filt => NRev rev => Gain gain => dac;

.5*4 => gain.gain;

13::second*8 => dur length;

70 => int minRand; // random number of milliseconds pulse on
750 => int maxRand; // or off
220*.5 => float minFreq; // randomized filter freq;
445*.5 => float maxFreq; //

.05 => rev.mix;

(minFreq+maxFreq)*.5 => filt.freq;
200 => filt.Q; // 20, 200, 1 for clicks

now + length => time future;

while (now < future) {
    1 => imp.next;
    Std.rand2(minRand,maxRand)::ms => now;
    0 => imp.next;
    Std.rand2f(minRand,maxRand)::ms => now;
    Std.rand2f(minFreq,maxFreq) =>filt.freq;
}
rev.mix()*1.5 => rev.mix;
5::second => now;