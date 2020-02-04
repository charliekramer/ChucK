adc => Gain gain => Echo echo => HPF filt => dac;

44 => filt.freq;
2 => filt.Q;

120./60*4 => float beatSec;

SqrOsc drive => SinOsc echoLFO => blackhole;

1./beatSec => drive.freq;
.5 => drive.gain;

1.75/beatSec => echoLFO.freq;
.5 => echoLFO.gain;

beatSec::second => dur beat;
4*beat => echo.max;
1.5*beat => echo.delay;
.9 => echo.gain;
.5 => echo.mix;
echo => echo;

.3 => gain.gain;

spork~LFOEcho();

30::second => now;

0 => gain.gain;

15::second => now;

fun void LFOEcho () {
    while (true) {
        (1+echoLFO.last())*beat*1.5 => echo.delay;
        1::samp => now;
    }
}


