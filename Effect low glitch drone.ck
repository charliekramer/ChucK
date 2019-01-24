SinOsc sin => Modulate mod => NRev rev => Gain gain => dac;

.02 => gain.gain;

200 => sin.freq; // this doesn't seem to affect anything

.9 => rev.mix;

<<< mod.vibratoRate(), mod.vibratoGain(), mod.randomGain() >>>;

 mod.vibratoRate() => float modRate;
 mod.vibratoGain() => float modGain;
 mod.randomGain() => float randGain;


60./120. => float beatsec;
beatsec::second => dur beat;

beat - (now % beat) => now;

while (true) {

20 => mod.vibratoRate; // 20 
100 => mod.vibratoGain; // 100 
10=> mod.randomGain; // 10 

<<< mod.vibratoRate(), mod.vibratoGain(), mod.randomGain() >>>;

//1=> sin.noteOn;

4*beat => now;

modRate => mod.vibratoRate; // - ( float , READ/WRITE ) - set rate of vibrato
modGain => mod.vibratoGain; // - ( float , READ/WRITE ) - gain for vibrato
randGain => mod.randomGain; // - ( float , READ/WRITE ) - gain for random contribution

<<< mod.vibratoRate(), mod.vibratoGain(), mod.randomGain() >>>;


4*beat => now;

}

  