.1 => float gainSet;

(60./94.)::second*2 => dur beat;

beat - (now % beat) => now;

[.9,.9,.9,.9] @=> float pHat[];
[.9,.1,.1,.1] @=> float pKick[];
[.1,.1,.5,.9] @=> float pSnare[];

[.1,.9,.5,.1] @=> float pTom1[];
[.1,.1,.9,.5] @=> float pTom2[];
[.1,.1,.5,.9] @=> float pTom3[];

[.1,.9,.5,.1,.5,.5] @=>  pTom1;
[.1,.1,.9,.5,.5,.1] @=>  pTom2;
[.1,.1,.5,.9,.5,.1] @=>  pTom3;


SndBuf snare => NRev snareRev => Gain gain => dac;
SndBuf kick => gain => dac;
SndBuf hat => gain => dac;
SndBuf tom1 => gain => dac;
SndBuf tom2 => gain => dac;
SndBuf tom3 => gain => dac;

0 => snare.loop => kick.loop => hat.loop => tom1.loop => tom2.loop => tom3.loop;

gainSet => gain.gain;

.1 => snareRev.mix;

spork~randRate(.5,1.5);//.5, 1.5,.01.,.1 pretty groove

"/Users/charleskramer/Desktop/chuck/audio/CYCdh_ElecK02-Snr01.wav" => snare.read;
"/Users/charleskramer/Desktop/chuck/audio/CYCdh_ElecK02-ClHat01.wav" => hat.read;
"/Users/charleskramer/Desktop/chuck/audio/CYCdh_ElecK02-Kick01.wav" => kick.read;
"/Users/charleskramer/Desktop/chuck/audio/CYCdh_ElecK02-Tom01.wav" => tom1.read;
"/Users/charleskramer/Desktop/chuck/audio/CYCdh_ElecK02-Tom02.wav" => tom2.read;
"/Users/charleskramer/Desktop/chuck/audio/CYCdh_ElecK02-Tom03.wav" => tom3.read;

1 => int j;


while (true) {
    spork~hatPlay(pHat,beat);
    spork~kickPlay(pKick,beat);
    spork~snarePlay(pSnare,beat);
    if (j % 8 == 0)  {
        spork~tom1Play(pTom1,beat);
        spork~tom2Play(pTom2,beat);
        spork~tom3Play(pTom3,beat);
    }
    beat => now;
    j++;
}


fun void hatPlay(float pHat[], dur beat) {
    for (0 => int i; i < pHat.size(); i++) {
        hat.samples() => hat.pos;
        if (Std.rand2f(0,1) < pHat[i]) {
            0 => hat.pos;
        }
        beat/pHat.size() => now;
    }
}

fun void kickPlay(float pKick[], dur beat) {
    for (0 => int i; i < pKick.size(); i++) {
        kick.samples() => kick.pos;
        if (Std.rand2f(0,1) < pKick[i]) {
            0 => kick.pos;
        }
        beat/pKick.size() => now;
    }
}

fun void snarePlay(float pSnare[], dur beat) {
    for (0 => int i; i < pSnare.size(); i++) {
        snare.samples() => snare.pos;
        if (Std.rand2f(0,1) < pSnare[i]) {
            0 => snare.pos;
        }
        beat/pSnare.size() => now;
    }
}

fun void tom1Play(float pTom1[], dur beat) {
    for (0 => int i; i < pTom1.size(); i++) {
        tom1.samples() => tom1.pos;
        if (Std.rand2f(0,1) < pTom1[i]) {
            0 => tom1.pos;
        }
        beat/pTom1.size() => now;
    }
}

fun void tom2Play(float pTom2[], dur beat) {
    for (0 => int i; i < pTom2.size(); i++) {
        tom2.samples() => tom2.pos;
        if (Std.rand2f(0,1) < pTom2[i]) {
            0 => tom2.pos;
        }
        beat/pTom2.size() => now;
    }
}

fun void tom3Play(float pTom3[], dur beat) {
    for (0 => int i; i < pTom3.size(); i++) {
        tom3.samples() => tom3.pos;
        if (Std.rand2f(0,1) < pTom3[i]) {
            0 => tom3.pos;
        }
        beat/pTom3.size() => now;
    }
}

fun void randRate(float min, float max) {
    while (true) {
        Std.rand2f(min,max) => kick.rate;
        Std.rand2f(min,max) => snare.rate;
        Std.rand2f(min,max) => hat.rate;
        Std.rand2f(min,max) => tom1.rate;
        Std.rand2f(min,max) => tom2.rate;
        Std.rand2f(min,max) => tom3.rate;
        .25*beat => now;
    }
}
        
        