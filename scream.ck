
class Fuzz extends Chugen
{
    1.0/2.0 => float p;
    
    2 => intensity;
    
    fun float tick(float in)
    {
        Math.sgn(in) => float sgn;
        return Math.pow(Math.fabs(in), p) * sgn;
    }
    
    fun void intensity(float i)
    {
        if(i > 1)
            1.0/i => p;
    }
}

.2 => float gainSet;

SawOsc sqr => PitShift pitch =>  ADSR env => Fuzz fuzz => Echo echo => Gain master => dac;

gainSet => master.gain;

431/(1.5) => sqr.freq;

1 => pitch.mix;
1 => pitch.shift;

10::second => dur A;
10::second => dur S;
10::second => dur R;
(A, S, 1., R) => env.set;

20::second => dur end;

SinOsc pitchLFO => blackhole;
.7 => pitchLFO.freq;
.3 => pitchLFO.gain;
Envelope pitchEnv => blackhole;
S=> pitchEnv.duration;
1 => pitchEnv.target;
200*4 => float pitchMult; //Math.pow(1+pitchEnv.value()*pitchMult, pitchPow) => pitchLFO.freq;
.4 => float pitchPow;

2::second => echo.max;
1.5::second => echo.delay;
.7 => echo.mix;
.7 => echo.gain;
echo => echo;

1=> env.keyOn;


now + A => time future;

while (now < future) {
    env.value() => pitch.shift;
    env.value() => sqr.gain;
    1::samp => now;
}

now + S => future;

1 => pitchEnv.keyOn;

while (now < future) {
    
    Math.pow(1+pitchEnv.value()*pitchMult, pitchPow) => pitchLFO.freq;
    env.value()*(1+pitchLFO.last()) => pitch.shift;
    env.value() => sqr.gain;
    10::ms => now;
  }

now + R => future;

1 => pitchEnv.keyOff;
1 => env.keyOff;

while (now < future) {
    
    Math.pow(1+pitchEnv.value()*pitchMult, pitchPow) => pitchLFO.freq;
    env.value()*(1+pitchLFO.last()) => pitch.shift;
    env.value() => sqr.gain;
    10::ms => now;
   }

end => now;

