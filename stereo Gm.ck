
.1 => float gainSet;
.01 => float delta;// pitch delta;

55 -12 => float midiBase;

5::second => dur beat;

spork~play();

2*beat => now;

fun void play() {
  
  Rhodey oscL[3];
  Rhodey oscR[3];
  NRev revL;
  NRev revR;
  Pan2 panL;
  Pan2 panR;
  
  Std.mtof(midiBase)*Std.rand2f(1-delta,1+delta) => oscL[0].freq;
  Std.mtof(midiBase)*Std.rand2f(1-delta,1+delta) => oscR[0].freq;
  Std.mtof(midiBase+3)*Std.rand2f(1-delta,1+delta) => oscL[1].freq;
  Std.mtof(midiBase+3)*Std.rand2f(1-delta,1+delta) => oscR[1].freq;
  Std.mtof(midiBase+7)*Std.rand2f(1-delta,1+delta) => oscL[2].freq;
  Std.mtof(midiBase+7)*Std.rand2f(1-delta,1+delta) => oscR[2].freq;
  
  for (0 => int i; i < 3; i++) {
      oscL[i] => revL => panL => dac;
      oscR[i] => revR => panR => dac;
      1 => oscL[i].noteOn;
      1 => oscR[i].noteOn; 
      Std.rand2f(0,1) => oscL[i].lfoSpeed;
      Std.rand2f(0,1) => oscL[i].lfoDepth;
      
      Std.rand2f(0,1) => oscL[i].lfoSpeed;
      Std.rand2f(0,1) => oscL[i].lfoDepth;
      }
    
   Std.rand2f(-1,0) => panL.pan;
   -panL.pan() => panR.pan; 
    
   beat => now;
    
    
}