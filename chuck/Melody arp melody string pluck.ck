// arp (up/down) with options for direction, randomly inserted octaves,
// random direction switching, beat divisions, pan, and doubling 

// set timing and synch
60./94. => float beattime;
beattime::second => dur beat;
beat - (now % beat) => now;
4. => float speed; //beat divisions

//soundchain
StifKarp moog => Gain g => Echo e => Pan2 p => dac;
0.5 => moog.pickupPosition; 
.1 => moog.sustain;
.1 => moog.stretch;

.2 => moog.gain;

.5 => g.gain;
0 => p.pan;

10::second => e.max;
beat*.3 => e.delay;
.9 => e.gain;
.2 => e.mix;
e => e;

// scale and base note 
 [0, 4, 5, 9, 12, 24] @=> int notes[];
58-36 => int baseNote;
  
 0 => int randOctave; // randomly insert octaves
 0 => int randDirection; // randomly switch direction
 0 => int double; // double each note
 0 => int panSwitching; // switch pan on each note (or note pair if doubled)
 if (panSwitching == 1) -1.0 => p.pan;
 1 => int noteOff; //to cut notes off
 
 0 => int i;  // don't change this, array index initialize
 1 => int delta; // don't change this, direction initialize
 
 "both" => string direction;  // up, down or both (both = default)
 
 if (direction == "up") {
     while (true) {
         
         Std.mtof(baseNote+notes[i]+randOctave*12*Std.rand2(0,1)) => moog.freq;
         1.0 => moog.noteOn;
         if (panSwitching == 1) -1.*p.pan() => p.pan;
		 if (noteOff == 1 ) {
		 	
		 	beat/speed*.5 => now;
	 	 }
	 	 else {
		    beat/speed => now;
		 }

		 	
         if (double !=0) {
             1.0 => moog.noteOn;
             beat/speed => now;
         }
         if (i == notes.cap()-1)  -1 => i;
         i++;
		 if (noteOff == 1) {
		 	
		     1 => moog.noteOff;
		     beat/speed*.5 => now;
		 }

     }
 }
     
     else if (direction == "down") {
         
         notes.cap()-1 => i;
             
         while (true) {
             
             Std.mtof(baseNote+notes[i]+randOctave*12*Std.rand2(0,1)) => moog.freq;
             1.0 => moog.noteOn;
             if (panSwitching == 1) -1.*p.pan() => p.pan;
			 if (noteOff == 1 ) {
			 	
			 	beat/speed*.5 => now;
		 	 }
		 	 else {
		 		beat/speed => now;
	 		 }
	 		
             if (double !=0) {
                 1.0 => moog.noteOn;
                 beat/speed => now;
             }
             if (i == 0)  notes.cap() => i;
             i--;
			 if (noteOff == 1) {
			 	
			 	1 => moog.noteOff;
			 	beat/speed*.5 => now;
		 	 }
		 	
         }
     }
     else {
 
          while (true) {
     
          Std.mtof(baseNote+notes[i]+randOctave*12*Std.rand2(0,1)) => moog.freq;
          1.0 => moog.noteOn;
          if (panSwitching == 1) -1.*p.pan() => p.pan;
		  if (noteOff == 1 ) {
		  	
		  	beat/speed*.5 => now;
	  	  }
	  	  else {
	  		beat/speed => now;
  		  }
  		
          if (double !=0) {
              1.0 => moog.noteOn;
              beat/speed => now;
          }
          if (randDirection != 0) {
              if (Std.rand2f(0.,1.) > .95) -1*=> delta;
          }
          if ((delta == 1 && i == notes.cap()-1) || (delta == -1 && i == 0)) -1*delta => delta;
          i + delta => i;
		  if (noteOff == 1) {
		  	
		  	1 => moog.noteOff;
		  	beat/speed*.5 => now;
	  	}
	  	
      }
     
 }
     
     
     
     