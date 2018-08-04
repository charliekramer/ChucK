// arp (up/down) with options for direction, randomly inserted octaves,
// random direction switching, beat divisions, pan, and doubling 

// set timing and synch
60./154. => float beattime;
beattime::second => dur beat;
beat - (now % beat) => now;
4. => float speed; //beat divisions

//soundchain
Moog moog => Gain g => Pan2 p => dac;
.5 => moog.filterQ;
2 => moog.filterSweepRate;

0.9 => g.gain;
0 => p.pan;

// scale and base note 
 [0, 4, 5, 9, 12, 24] @=> int notes[];
 57=> int baseNote;
  
 0 => int randOctave; // randomly insert octaves
 0 => int randDirection; // randomly switch direction
 0 => int double; // double each note
 0 => int panSwitching; // switch pan on each note (or note pair if doubled)
 if (panSwitching == 1) -1.0 => p.pan;
 
 0 => int i;  // don't change this, array index initialize
 1 => int delta; // don't change this, direction initialize
 
 "both" => string direction;  // up, down or both (both = default)
 
 if (direction == "up") {
     while (true) {
         
         Std.mtof(baseNote+notes[i]+randOctave*12*Std.rand2(0,1)) => moog.freq;
         1.0 => moog.noteOn;
         if (panSwitching == 1) -1.*p.pan() => p.pan;
         beat/speed => now;
         if (double !=0) {
             1.0 => moog.noteOn;
             beat/speed => now;
         }
         if (i == notes.cap()-1)  -1 => i;
         i++;
     }
 }
     
     else if (direction == "down") {
         
         notes.cap()-1 => i;
             
         while (true) {
             
             Std.mtof(baseNote+notes[i]+randOctave*12*Std.rand2(0,1)) => moog.freq;
             1.0 => moog.noteOn;
             if (panSwitching == 1) -1.*p.pan() => p.pan;
             beat/speed => now;
             if (double !=0) {
                 1.0 => moog.noteOn;
                 beat/speed => now;
             }
             if (i == 0)  notes.cap() => i;
             i--;
         }
     }
     else {
 
          while (true) {
     
          Std.mtof(baseNote+notes[i]+randOctave*12*Std.rand2(0,1)) => moog.freq;
          1.0 => moog.noteOn;
          if (panSwitching == 1) -1.*p.pan() => p.pan;
          beat/speed => now;
          if (double !=0) {
              1.0 => moog.noteOn;
              beat/speed => now;
          }
          if (randDirection != 0) {
              if (Std.rand2f(0.,1.) > .95) -1*=> delta;
          }
          if ((delta == 1 && i == notes.cap()-1) || (delta == -1 && i == 0)) -1*delta => delta;
          i + delta => i;
      }
     
 }
     
     
     
     