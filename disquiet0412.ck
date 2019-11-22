
Pan2 pan[21];

Rhodey rhodes => Gain gain => NRev rev => pan[0] => dac;
Flute flute => gain => rev => pan[1] => dac;
VoicForm voice => gain => rev => pan[2] => dac;  
BandedWG bwg => gain => rev => pan[3] => dac;
BlowBotl botl => gain => rev => pan[4] => dac;
BlowHole blow => gain => rev => pan[5] => dac;
Bowed bowed => gain => rev => pan[6] => dac; 
Brass brass => gain => rev => pan[7] => dac; 
Clarinet  clarinet => gain => rev => pan[8] => dac;
Mandolin mandolin => gain => rev => pan[9] => dac;
ModalBar bar => gain => rev => pan[10] => dac;
Moog  moog =>gain => rev => pan[11] =>  dac; 
Saxofony sax => gain => rev => pan[12] => dac; 
Sitar sitar => gain => rev => pan[13] => dac; 
StifKarp karp => gain => rev => pan[14] => dac; 
BeeThree b3 => gain => rev => pan[15] => dac; 
FMVoices fmv => gain => rev => pan[16] => dac;
HevyMetl hm => gain => rev => pan[17] => dac; 
PercFlut percflut => gain => rev => pan[18] => dac;
TubeBell tube => gain => rev => pan[19] => dac; 
Wurley   wurley => gain => rev => pan[20] => dac; 

SinOsc LFO => blackhole;

.05 => LFO.freq;

.1 => rev.mix;

57 => float midiBase;

[0., 7., 10. ,17] @=> float notes[];

2::second => dur beat;

now + 30::second => time future;

while (now < future) {
    setFreqs();
    setPans();
    notesOn();
    (2.2-LFO.last())*.001 => gain.gain;
    <<< gain.gain() >>>;
    Std.rand2f(.9,1.1)*beat => now;
    
}   

.7 => rev.mix;
gain.gain()*.7 => gain.gain;
setFreqs();
setPans();
notesOn();
Std.rand2f(.9,1.1)*beat*2 => now;
.9 =>rev.mix;
notesOff();
Std.rand2f(.9,1.1)*beat*4 => now;
    

fun void setFreqs() {
    
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>rhodes.freq;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>flute.freq;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>voice.freq;  
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>bwg.freq;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>botl.freq;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>blow.freq;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>bowed.freq; 
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>brass.freq; 
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>clarinet.freq;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>mandolin.freq;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>bar.freq;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>moog.freq; 
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>sax.freq; 
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>sitar.freq; 
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>karp.freq; 
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>b3.freq; 
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>fmv.freq;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>hm.freq; 
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>percflut.freq;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>tube.freq; 
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) =>wurley.freq;

}

fun void notesOn () {
    
    Std.rand2f(0,1)*(2+LFO.last())*.3  => rhodes.noteOn;;
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>flute.noteOn;;
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>voice.noteOn;;  
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>bwg.noteOn;;
    Std.rand2f(0,1)*(2+LFO.last())*.3  => botl.noteOn;;
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>blow.noteOn;;
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>bowed.noteOn;; 
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>brass.noteOn;; 
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>clarinet.noteOn;;
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>mandolin.noteOn;;
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>bar.noteOn;;
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>moog.noteOn;; 
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>sax.noteOn;; 
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>sitar.noteOn;; 
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>karp.noteOn;; 
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>b3.noteOn;; 
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>fmv.noteOn;;
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>hm.noteOn;; 
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>percflut.noteOn;;
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>tube.noteOn;; 
    Std.rand2f(0,1)*(2+LFO.last())*.3  =>wurley.noteOn;;
    
}

fun void setPans() {
    
    for (0 => int i; i < pan.cap(); i++) {
        Std.rand2f(-1,1) => pan[i].pan;
    }
}
   
fun void notesOff () {
   
    1  => rhodes.noteOff;;
    1  =>flute.noteOff;;
    1  =>voice.noteOff;;  
    1  =>bwg.noteOff;;
    1  => botl.noteOff;;
    1  =>blow.noteOff;;
    1  =>bowed.noteOff;; 
    1  =>brass.noteOff;; 
    1  =>clarinet.noteOff;;
    1  =>mandolin.noteOff;;
    1  =>bar.noteOff;;
    1  =>moog.noteOff;; 
    1  =>sax.noteOff;; 
    1  =>sitar.noteOff;; 
    1  =>karp.noteOff;; 
    1  =>b3.noteOff;; 
    1  =>fmv.noteOff;;
    1  =>hm.noteOff;; 
    1  =>percflut.noteOff;;
    1  =>tube.noteOff;; 
    1  =>wurley.noteOff;;
    
} 