Bowed bowed[3] => dac;

.05*2 => float gainSet;
200 => int iterations;

59-12 => int baseMidiNote;

60./80. => float beatsec;
beatsec::second => dur beat;

beat - (now % beat) => now;

Std.mtof(baseMidiNote) => bowed[0].freq;
Std.mtof(baseMidiNote+7) => bowed[1].freq; // was +7
Std.mtof(baseMidiNote+9) => bowed[2].freq; // was +9

bowed[0] => PRCRev rev => Dyno dyn => dac;
bowed[1] => rev => dyn => dac;
bowed[2] => rev => dyn => dac;

gainSet => bowed[0].gain => bowed[1].gain => bowed[2].gain;

1 => bowed[0].noteOn => bowed[1].noteOn => bowed[2].noteOn;

0.5 => bowed[0].bowPressure => bowed[1].bowPressure => bowed[2].bowPressure;
0.7 => bowed[0].bowPosition => bowed[1].bowPosition => bowed[2].bowPosition;

//spork~revSweep(rev); 
spork~revSweepLFO(rev);

0 => int j;

while (j < iterations) {
	
	j++;
    
    4*beat => now;
    for (0 => int i; i <= 2; i++) {
        Std.rand2f(0.4,0.6) => bowed[i].bowPressure;
        Std.rand2f(0.3,.7) => bowed[i].bowPosition;
    }
}

now + 15::second => time future;

while (now < future) {
	
	gainSet*.95 => gainSet;
	gainSet => bowed[0].gain => bowed[1].gain => bowed[2].gain;
	.1::second =>now;
	
}


fun void revSweep (PRCRev rev) {
    0 => rev.mix;
    0.001 => float mixDelta;
    while (true) {
        rev.mix()+mixDelta => rev.mix;
        if (rev.mix() >= 1 || rev.mix() <=0 )  -1*=> mixDelta;
        .01::second => now;
    }
}
  
fun void revSweepLFO (PRCRev rev) {
      SinOsc sin => blackhole;
      SinOsc sin2 => blackhole;
      .2 => sin.freq;
      .7 => sin.gain;
      .1 => sin2.gain; // change this to .5 for wobble
      5 => sin2.freq;
      0 => rev.mix;
      0.001 => float mixDelta;
      while (true) {
          sin.last()*sin2.last() => rev.mix;
          .0001::second => now;
      }
}

 
       



