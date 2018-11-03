BeeThree s[3];
NRev rev;
Chorus c;
ADSR env;
Echo echo;
Pan2 pan[2];
Dyno dyn;

0.005 => s[0].gain => s[1].gain => s[2].gain;

<<< s[0].gain(), s[1].gain(), s[2].gain() >>>;

env.set(4::second, .75::second, .9, 8::second);
20::second => echo.max;
4::second*1.5/4. => echo.delay;
.3 => echo.gain;
echo => echo;

58-12 => int midiBase;
Std.mtof(midiBase) => s[0].freq;
3 => int noteDiff;
Std.mtof(midiBase+noteDiff) => s[1].freq;
Std.mtof(midiBase+noteDiff*2) => s[2].freq;

.1 => s[0].lfoSpeed => s[1].lfoSpeed => s[2].lfoSpeed;

.1 => s[0].lfoDepth => s[1].lfoDepth => s[2].lfoDepth;

// interesting to make depth hgh (2) and speed slow (0.01)

0.4 => rev.mix;

.01 => c.modFreq;
1. => c.modDepth;
.5 => c.mix;

s[0] => env => c => echo => rev => dyn => dac;
s[1] => env => c => echo => rev => pan[0] => dyn => dac;
s[2] => env => c => echo => rev => pan[1] => dyn => dac;

-1. => pan[0].pan;
1. => pan[1].pan;

while (true) {

    for (1 => int i; i<= 7; i++) {
    
        i => noteDiff;
        Std.mtof(midiBase+noteDiff) => s[1].freq;
        Std.mtof(midiBase+noteDiff*2-1) => s[2].freq;
        1 => s[0].noteOn; 1 => s[1].noteOn; 1 => s[2].noteOn;
        1=>env.keyOn;
        5::second => now;
        1 => env.keyOff;
        10::second => now;
    }

    for (6 => int i; i> 0; i--) {
    
        i => noteDiff;
        Std.mtof(midiBase+noteDiff) => s[1].freq;
        Std.mtof(midiBase+noteDiff*2-2) => s[2].freq;
        1 => s[0].noteOn; 1 => s[1].noteOn; 1 => s[2].noteOn;
        1=>env.keyOn;
        5::second => now;
        1 => env.keyOff;
        10::second => now;
    }

    for (1 => int i; i<= 7; i++) {
        
        i => noteDiff;
        Std.mtof(midiBase+noteDiff) => s[1].freq;
        Std.mtof(midiBase+noteDiff*2-Std.rand2(0,3)) => s[2].freq;
        1 => s[0].noteOn; 1 => s[1].noteOn; 1 => s[2].noteOn;
        1=>env.keyOn;
        5::second => now;
        1 => env.keyOff;
        10::second => now;
    }

    for (6 => int i; i> 0; i--) {
	
    	i => noteDiff;
    	Std.mtof(midiBase+noteDiff) => s[1].freq;
	    Std.mtof(midiBase+noteDiff*2-Std.rand2(0,3)) => s[2].freq;
	    1 => s[0].noteOn; 1 => s[1].noteOn; 1 => s[2].noteOn;
	    1=>env.keyOn;
	    5::second => now;
	    1 => env.keyOff;
	    10::second => now;
    }

}
