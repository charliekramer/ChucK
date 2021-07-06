.01/6. => float gainSet;

41 => float midiBase;

5::minute => dur length;

60./120 *2 => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

Rhodey rhodes[3];
Wurley wurley[3];

Gain gain;

LPF filt;
Echo echo;
NRev rev[2];

PitShift pitch;
1 => pitch.mix;
Std.mtof(midiBase+2)/Std.mtof(midiBase) => pitch.shift;

Pan2 pan[2];

for (0 => int i; i < 3; i++) {
    gainSet => rhodes[i].gain; 
    gainSet => wurley[i].gain;
    rhodes[i] => gain => rev[0] => pan[0] => dac;
    wurley[i] => gain => rev[0] => pan[0] => dac;
    }
.7 => pan[0].pan;
-pan[0].pan() => pan[1].pan;    

Std.mtof(midiBase) => rhodes[0].freq => wurley[0].freq;
Std.mtof(midiBase+4) => rhodes[1].freq => wurley[1].freq;
Std.mtof(midiBase+7) => rhodes[2].freq => wurley[2].freq;

gain => Gain echoGain => echo => pitch => rev[1] => pan[1] => dac;

Std.mtof(midiBase)*10 => filt.freq;
2 => filt.Q;

200 => echoGain.gain;

4*beat => echo.max => echo.delay;
.7=> echo.gain;
1 => echo.mix;
//echo => echo;

now + length => time future;

while (now < future) {
    
    for (0 => int i; i < 3; i++) {
        1 => rhodes[i].noteOn;
        1 => wurley[i].noteOn;
        }
    4*beat => now;
    for (0 => int i; i < 3; i++) {
        1 => rhodes[i].noteOff;
        1 => wurley[i].noteOff;
    }
    4*beat => now;
    
    
}

