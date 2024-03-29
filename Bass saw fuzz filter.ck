// put fuzz before filter 
// double up fuzz
// two filters
// try sqr and tri for LFO
// makes ascending/descending melody

// fuzz bass ChuGen by Esteban Betancur https://github.com/essteban/chuckEFXs/tree/master/DigitalDistortion
// ChuGen
// Create new UGens by performing audio-rate processing in ChucK

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

.002*.5 => float gainSet;
60./94. => float beattime;
beattime::second => dur beat;
beat - (now % beat ) => now;

SawOsc s[3];
s[0] => LPF filtLP =>  Fuzz f =>  Dyno d => Gain g => dac;
s[1] => HPF filtHP => f => d => g => dac;
s[2] => BPF filtBP => f => d => g => dac;

SinOsc v => FullRect rect => blackhole; // modulate gain of other sinoscs
(1./beattime)/5. => v.freq;
2 => v.gain; // 0 for normal-ish sound

.0 => s[1].gain => s[2].gain; // pick one, 0 is most normal sounding
g.gain(gainSet);

SinOsc t => blackhole; // try sqr and tri for different patterns
.1 => t.freq;
1 => t.gain;

Std.mtof(55-24) => s[0].freq => s[1].freq => s[2].freq;
10=>filtBP.Q => filtLP.Q => filtHP.Q;

1./beattime*.25=> t.freq;  //for regular sounding cycles
//beattime*4 => t.freq;  //for offset sounding cycles

15 => f.intensity;


now + 128*beat => time future;

while (now < future) {
	v.last() => s[1].gain => s[2].gain;
	(4.9+t.last()*4)*(s[0].freq()) => filtLP.freq => filtBP.freq => filtHP.freq;
    beat*.25 => now;

}



