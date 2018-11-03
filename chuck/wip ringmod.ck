// simple ring modulator

60./94. => float beatSec;

beatSec::second => dur beat;

beat - (now % beat) => now;

SinOsc carrier => blackhole;
SinOsc modulator => blackhole;

Blit plus => Gain modGain => dac;
Blit minus => modGain => dac;

220 => carrier.freq;

.1 => float freqMult;
.05 => float freqDelta;

.2 => modGain.gain;

while (true)
{

carrier.freq()*(Std.rand2f(1,4))*freqMult => modulator.freq;

carrier.freq()+modulator.freq() => plus.freq;
carrier.freq()-modulator.freq() => minus.freq;

Std.rand2(1,6) => plus.harmonics;
Std.rand2(1,6) => minus.harmonics;

beat/4 => now;

freqMult + freqDelta => freqMult;

if (freqMult > 4. || freqMult < .1) -1*=>freqDelta;


}
