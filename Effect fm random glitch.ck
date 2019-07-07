// basic FM synthesis using SinOsc with random mod freq and synch
// option to super glitch using pitch change

// modulator to carrier

.025 => float gainSet;

SinOsc m => SinOsc c => LPF l => Gain gL  => Dyno dL => dac.left;

c => Echo e => l => Gain gR => Dyno dR => dac.right; 

gainSet=> gL.gain => gR.gain;

60./94.*.5 => float beatSec;

beatSec::second => dur baseBeat;
baseBeat => dur beat;
10::second => e.max;
beat*2.5 => e.delay;
e => e;
.5 => e.gain;
.5 => e.mix;


// carrier frequency
Std.mtof(55-36) => float cfreqBase => c.freq; //try 30, 60, 300, NOT 3000; 1-3 generates pitches
// modulator frequency
100 => m.freq;
// index of modulation
300 => m.gain;


// phase modulation is FM synthesis (sync is 2)
2 => c.sync;

1 => int pitchDirection;
50 => float pitchDelta;
250 => int pitchDiv;

1 => int pitchGlitch;

// time-loop
while( true ) {
    
     Std.rand2(1,2) => c.sync;
     Std.rand2f(c.freq()*.5, c.freq()/.5) => m.freq;
     Std.rand2f(c.freq()*2,c.freq()*36) => l.freq;
     baseBeat*Std.rand2f(.8,1./.8) => beat;
     if (pitchGlitch == 1) {   
         for (0 => int j; j< pitchDiv; j++) {
             c.freq()*(1+Std.rand2f(0,1)*pitchDirection*pitchDelta)=>c.freq;
             beat/pitchDiv => now;
         }
         cfreqBase => c.freq;
         Std.rand2(-1,1) => pitchDirection;
     }
     else beat => now;
 }
