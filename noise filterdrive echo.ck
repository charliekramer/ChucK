Noise noise => ADSR env => BPF filt =>  Dyno dyn => Echo echo => NRev rev => dac.left;
rev => Chorus chorus => dac.right;

1 => dyn.gain; //master gain

.05 => chorus.modFreq;

100 => float noiseGain;

noiseGain => noise.gain;

Std.mtof(57) => filt.freq;
200 => filt.Q;

10::second => echo.max;
8::second => echo.delay;
.7 => echo.gain;
.5 => echo.mix;
echo => echo;

(2::second, .1::second, 1, 2::second) => env.set;

1 => env.keyOn;
4::second => now;
1 => env.keyOff;
120::second => now;