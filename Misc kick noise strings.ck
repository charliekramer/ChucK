class StringPatch {
    
    10 => int n;
    220 => float baseFreq;
    .1 => static float spr;
    1 => float masterGain;
    
    SawOsc sin[n];
    
    for (0 => int i; i < n; i++) {
        baseFreq*(1+spr*i*Math.pow(-1,i)) => sin[i].freq;
        //		<<< i, sin[i].freq() >>>;
        masterGain => sin[i].gain;
    }
    
    fun void nOsc(int tempN) {
        tempN => n;
        //		<<< "nOsc", n>>>;
    }
    
    fun float spread(float tempSpread) {
        tempSpread => spr;
        for (0 => int i; i < n; i++) {
            baseFreq*(1+spr*i*Math.pow(-1,i)) => sin[i].freq;
        }
    }
    
    fun void freq(float tempFreq) {
        tempFreq => baseFreq;
        for (0 => int i; i < n; i++) {
            baseFreq*(1+spr*i*Math.pow(-1,i)) => sin[i].freq;
        }
    }
    
    fun void gain(float tempGain) {
        tempGain => masterGain;
        for (0 => int i; i < n; i++) {
            masterGain => sin[i].gain;
        }
    }
    
    fun void connect(UGen ugen) {
        for (0 => int i; i < n; i++) {
            sin[i] => ugen;
        }
    }
    
}
StringPatch s1;
StringPatch s2;
StringPatch s3;

spork~spread_LFO(.5,.1);

1 => float spreadMult; // > 1 => weirder

59-24 => float midiBase;// 
.005*spreadMult => float spread => s1.spread => s2.spread => s3.spread;
3 => s1.nOsc;
Std.mtof(midiBase) => s1.freq;
3 => s2.nOsc;
Std.mtof(midiBase+4) => s2.freq;
3 => s3.nOsc;
Std.mtof(midiBase+7) => s3.freq;


Gain g => ADSR env => HPF filter => NRev rev => dac;


.005 => g.gain;

s1.connect(g);
s2.connect(g);
s3.connect(g);

[[0, 4, 7],
 [2, 5, 9],
 [4, 7, 11],
 [5, 9, 12],
 [7, 11, 14],
 [9, 12, 16],
 [11, 14, 17],
 [12, 16, 19]]  @=> int notes[][];

Std.mtof(midiBase)*1 => filter.freq;
10 => filter.Q;

.5 => rev.mix;

Impulse imp => LPF filtImp => Gain gainImp => dac;
Noise noise => BPF filtNoise => Envelope envNoise => Gain gainNoise => dac;

20 => imp.gain;
1 => noise.gain;
g.gain()*10 => gainImp.gain => gainNoise.gain;

1 => int state; // on or off strings;
.5 => float p; // probability of switching states

30 => filtImp.freq;
5 => filtImp.Q;

110 => filtNoise.freq;
3 => filtNoise.Q;

60./80.*.5 => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

45::second => dur length;

(8*beat,.0::second, .9, 7*beat) => env.set;

now + length => time future;

while (now < future) {
    
    if (Std.rand2f(0,1) > p) {
        flipState();
        if (state == 1) load_notes(Std.rand2(0,7));
    }
        
    
    for (1 => int i; i <= 8; i++) {
        
        if (i == 1 || i == 8) 100 => imp.next;
        
        1 => envNoise.keyOn;
        .25*beat =>  now;
        1 => envNoise.keyOff;
        .75*beat => now;
    }
    
}

1 => env.keyOff;
16*beat => now;




fun void spread_LFO (float freq, float gain) {
    
    SinOsc LFO => blackhole;
    freq => LFO.freq;
    gain => LFO.gain;
    while (true) {
        (1+LFO.last())*spread => s1.spread;
        (1+LFO.last())*spread => s2.spread;
        (1+LFO.last())*spread => s3.spread;
        1::samp => now;
    }
}

fun void load_notes(int row) {
    Std.mtof(midiBase+notes[row][0]) => s1.freq;
    Std.mtof(midiBase+notes[row][1]) => s2.freq;	
    Std.mtof(midiBase+notes[row][2]) => s3.freq;
    <<< "notes",midiBase+notes[row][0], midiBase+notes[row][1], midiBase+notes[row][2] >>>;
    
}

fun void flipState() {
    if (state == 0) {
        1 => state;
        1 => env.keyOn;
    }
        else {
            0 => state;
            1 => env.keyOff;
        }
}
