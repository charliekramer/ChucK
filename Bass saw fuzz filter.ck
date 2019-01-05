// put fuzz before filter 
// double up fuzz
// two filters
// try sqr and tri for LFO

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

60./120. => float beattime;
beattime::second => dur beat;
beat - (now % beat ) => now;

SawOsc s[3];
s[0] => LPF filtLP =>  Fuzz f =>  Dyno d => Gain g => dac;
s[1] => HPF filtHP => f => d => g => dac;
s[2] => BPF filtBP => f => d => g => dac;

0. => s[1].gain => s[2].gain; // pick one, 0 is most normal sounding
g.gain(.02);

SinOsc t => blackhole;

Std.mtof(36) => s[0].freq => s[1].freq => s[2].freq;
10=>filtBP.Q => filtLP.Q => filtHP.Q;

1./beattime*.25=> t.freq;  //for regular sounding cycles
//beattime*4 => t.freq;  //for offset sounding cycles

15 => f.intensity;


now + 128*beat => time future;

while (now < future) {
	(4.9+t.last()*4)*(s[0].freq()) => filtLP.freq => filtBP.freq => filtHP.freq;
    beat*.25 => now;

}



