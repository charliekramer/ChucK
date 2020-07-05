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

Noise noise => BPF BPfilt => LPF LPfilt => NRev rev =>  Gain gain =>  Pan2 pan1 => dac;
gain =>  Echo echo =>  NRev echoRev => Pan2 pan2 => dac;
echo => Fuzz fuzz => NRev fuzzRev => dac;

Envelope env; // doesn't help with clicking from change in echo time

.4 => noise.gain; //.2

1 => int chooser; // 1 => discrete echo (pitch) changes; 2 => interpolated

.2 => echoRev.mix; //.2
.5 => fuzzRev.mix; //.5

.5 => float lowFilt; // low and high cutoffs for filter shock distribution
2 => float hiFilt; // .5, 1

.5 => float lowStep; //low and high cutoffs for steptime shock distribution
2 => float hiStep; // .5, 2

.5::second => env.duration; //.5

1./1.5 => float echoScale; // controls overall pitch

.0 => fuzz.gain;
1 => fuzzRev.gain;
25 => fuzz.intensity;

-1 => pan1.pan; // -1
1 => pan2.pan; // 1

100::ms => echo.max;
10::ms => echo.delay;
.5 => echo.mix; // .5
.7 => echo.gain; //.7
echo => echo;

[10::ms, 20::ms, 19::ms, 25::ms, 23::ms] @=> dur echoDur[];
//[10::ms, 20::ms, 11::ms, 25::ms, 21::ms] @=> dur echoDur[];

for (0 => int i; i < echoDur.cap(); i++) {
    echoDur[i]*echoScale => echoDur[i];
}

[.7, .7,.7,.7,.7  ] @=> float echoGain[];

.2 => rev.mix; //.2

5 => BPfilt.Q; //5
2 => LPfilt.Q; //2
220 => float baseFreq; //220

5::second => dur length; //5 sec
.01::second => dur stepTime; // .01
length/stepTime => float steps;
0 => float iStep;

now + length => time future;

if (chooser == 1) {
    
    for (0 => int i; i < echoDur.cap(); i++) {
        echoDur[i] => echo.delay;
        echoGain[i] => echo.gain;
        1 => env.keyOn;
        while (now < future) {
            Std.rand2f(lowFilt,hiFilt)*baseFreq => BPfilt.freq;
            BPfilt.freq()*2 => LPfilt.freq;
            stepTime*Std.rand2f(lowStep,hiStep) => now;
        }
        now + length =>  future;
        1 => env.keyOff;
    }
}

if (chooser == 2) {
    for (0 => int i; i < echoDur.cap()-1; i++) {
        echoDur[i] => echo.delay;
        echoGain[i] => echo.gain;
        1 => env.keyOn;
        0 => iStep;
        while (now < future) {
            echoDur[i]*(1-iStep/steps) + echoDur[i+1]*iStep/steps => echo.delay;
            Std.rand2f(lowFilt,hiFilt)*baseFreq => BPfilt.freq;
            BPfilt.freq()*2 => LPfilt.freq;
            stepTime*Std.rand2f(lowStep,hiStep) => now;
            iStep + 1 => iStep;
        }
        now + length =>  future;
        1 => env.keyOff;
    }
}


0 => noise.gain;
now + 10::second => future;

<<< "outro" >>>;

while (now < future) {
    noise.gain()*.99 => noise.gain;
    10::ms => now;
}
    