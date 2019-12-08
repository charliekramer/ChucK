 ModalBar bar => LPF filter => Pan2 pan => dac;
 Noise noise => Envelope env => filter => pan => dac;
 
 .01 => noise.gain;
 
 SinOsc thetaLFO => blackhole; 
 
 57 => float midiBase;
 Std.mtof(midiBase) => bar.freq;
 
 .1 => thetaLFO.freq;
 1 => filter.gain;
 bar.freq() => filter.freq;
 
 100::ms => dur beat;
 //beat / 10::second => thetaLFO.freq;
 
 float theta;
 
 now + 30::second => time future;
 
 while (now < future) {
     
     thetaLFO.last()*2*pi => theta;
     Math.cos(theta) => pan.pan;
     (2+Math.sin(theta))*bar.freq() => filter.freq;
     1 => bar.noteOn;
     1 => env.keyOn;
     beat => now;
     1 => bar.noteOff;
     1 => env.keyOff;
     beat => now;
 }
 