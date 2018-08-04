// fat osc bass

60./154.*2 => float beattime; //sets time to BPM; 154 = BPM in this case
beattime::second => dur beat; // this is one beat
beat - (now % beat) => now; //synchronizes time to the beat (for multiple shreds)

SawOsc s[3] ; //create 3 saws
s[0] => LPF l  => Pan2 pan0 => dac; //connect each to panning, low pass filter and DAC
s[1] => l => Pan2 pan1 => dac;
s[2] => l => Pan2 pan2 => dac;

-1. => pan1.pan; // pan the second and third saws hard left and right
1 => pan2.pan;

0.2 => float gainset; // base level of volume "on"

.1 => float diff; // frequency differential across oscillators

220/2=> s[0].freq; //this is the base frequency
s[0].freq() + diff => s[1].freq; //spread around base frequency
s[0].freq() - diff => s[2].freq;

s[0].freq()*5 => l.freq; // set LPF cutoff high enough for desired sound

4 => float beatdiv; // use this to speed up or slow down beats in loop

while (true) {
    
    gainset => s[0].gain => s[1].gain => s[2].gain; //set all gains to the base level
    beat/beatdiv => now; //play note
    0.0 => s[0].gain => s[1].gain => s[2].gain; //turn gain off
    beat/beatdiv => now; // play silence
    
}

    




