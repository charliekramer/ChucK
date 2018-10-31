Bowed bowed[3] => dac;

58-12 => int baseMidiNote;

Std.mtof(baseMidiNote) => bowed[0].freq;
Std.mtof(baseMidiNote+7) => bowed[1].freq;
Std.mtof(baseMidiNote+9) => bowed[2].freq;

bowed[0] => PRCRev rev => Dyno dyn => dac;
bowed[1] => rev => dyn => dac;
bowed[2] => rev => dyn => dac;

.2 => bowed[0].gain => bowed[1].gain => bowed[2].gain;

1 => bowed[0].noteOn => bowed[1].noteOn => bowed[2].noteOn;

0.5 => bowed[0].bowPressure => bowed[1].bowPressure => bowed[2].bowPressure;
0.7 => bowed[0].bowPosition => bowed[1].bowPosition => bowed[2].bowPosition;

//spork~revSweep(rev); 
spork~revSweepLFO(rev);

while (true) {
    
    10::second => now;
    for (0 => int i; i <= 2; i++) {
        Std.rand2f(0.4,0.6) => bowed[i].bowPressure;
        Std.rand2f(0.3,.7) => bowed[i].bowPosition;
    }
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
      .1 => sin2.gain;
      5 => sin2.freq;
      0 => rev.mix;
      0.001 => float mixDelta;
      while (true) {
          sin.last()*sin2.last() => rev.mix;
          .0001::second => now;
      }
}

 
       



