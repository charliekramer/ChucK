// FM with two modulators
// to add: filter sweep; SinOsc phase shift

60./120.*.5 => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

2. => float beatdiv;

SinOsc s =>  PitShift p => LPF f => DelayA del => Dyno d => dac;
SqrOsc lfo1 => blackhole;
SqrOsc lfo2 => blackhole;

60 => s.freq => float sFreqBase;
0.1 => s.gain;
0.05 => p.shift;
.8 => p.mix;

3000 => f.freq;
1 => f.Q;

5::second => del.max;
beat*1.5 => del.delay;
.8 => del.gain;
del => del;
del => Pan2 pan;

1=>pan.pan;

// set the frequency of the lfos

5.1 => float ratio1; //frequency ratio for FM1
7.3 => float ratio2; // frequency ratio for FM1
ratio1*s.freq() => lfo1.freq;
6 => lfo1.gain;
ratio2*s.freq() => lfo2.freq;
6 => lfo2.gain;

.2 => float ifRand; //to add random variability

while (beat/beatdiv => now)
{
    // multiply modulators
   ( (lfo1.last()*lfo2.last())* (1+ifRand*Std.rand2f(-1,10.))*10 ) + 1*sFreqBase => s.freq;
    // add modulators
//   ( (lfo1.last()+lfo2.last())* (1+ifRand*Std.rand2f(0.,1.))*10 ) + 440 => s.freq;
//   -1.0*pan.pan()=> pan.pan;
 }

