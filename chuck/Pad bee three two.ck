// pad bee three with creepy rhodes sequence

BeeThree s[4];
NRev rev;
Chorus c;
ADSR env;
Echo echo;
Pan2 pan[2];
Dyno dyn;

0.01 => s[0].gain => s[1].gain => s[2].gain => s[3].gain;


env.set(4::second, .75::second, .9, 8::second);
20::second => echo.max;
4::second*1.5/4. => echo.delay;
.3 => echo.gain;
echo => echo;

59-12 => int midiBase;
[0, 3, 5, 7] @=> int notes1[];
[2, 6, 6, 8] @=> int notes2[];


0.1 => s[0].lfoSpeed => s[1].lfoSpeed => s[2].lfoSpeed => s[3].lfoSpeed;

0.1 => s[0].lfoDepth => s[1].lfoDepth => s[2].lfoDepth => s[3].lfoSpeed;

// interesting to make depth hgh (2) and speed slow (0.01)

0.4 => rev.mix;

.01 => c.modFreq;
1. => c.modDepth;
.5 => c.mix;

s[0] => env => c => echo => rev => dyn => dac;
s[1] => env => c => echo => rev => pan[0] => dyn => dac;
s[2] => env => c => echo => rev => dyn => dac;
s[3] => env => c => echo => rev => pan[1] => dyn => dac;

-1. => pan[0].pan;
1. => pan[1].pan;

while (true) {


    for (0 => int i; i < notes1.cap()-1; i++) {
    	Std.mtof(midiBase+notes1[i]) => s[i].freq;
	    1 => s[i].noteOn;
    }
	
    1=>env.keyOn;
    5::second => now;
	1 => env.keyOff;
	10::second => now;


for (0 => int i; i < notes2.cap()-1; i++) {
	Std.mtof(midiBase+notes2[i]) => s[i].freq;
	1 => s[i].noteOn;
	}
    1=>env.keyOn;
    5::second => now;
	1 => env.keyOff;
	10::second => now;



   }
