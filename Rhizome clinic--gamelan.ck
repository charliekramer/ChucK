// "gamelan" ChucK code for Rhizome clinic by Charlie Kramer (taos.points@gmail.com)
// this document includes:
// 1. very basic ChucK syntax
// 2. the code
// 3. suggested exercises
// 4. list of references

// 1. very basic Chuck syntax:
//  // double slash--this is a comment line (not executed)
//  /*  followed by */ also delineates comments
//  =>  "ChucK" operator; makes a connection or puts a value into something
//  ;   ends a line
//  Std.name() or Math.name()  libraries that do things like math operations or conversions
//  dac  digital audio converter (connects the digital inside of the computer to something audible)
//  int, float  integer and floating-point (decimal) numbers
//  [time] => now; do something for [time] amount of time 

// 2. code for Gamelan; create a five-note (pentatonic) melody 

 ModalBar bar => dac; // this connects a sound generator that makes a struck-bar sound to the dac
 
66-12 => int baseNote; // create an integer called baseNote and set it to midi note 66 (F# above middle C). Our tune is in this key.

Std.mtof(baseNote+9) => float freq1; // here's the first note of our melody (F#) (using mtof or "MIDI to Frequency")
Std.mtof(baseNote+7) => float freq2; // second note
Std.mtof(baseNote+4) => float freq3; // third note
Std.mtof(baseNote-7) => float freq4; // fourth note
Std.mtof(baseNote-8) => float freq5; // fifth note

// five notes = pentatonic scale, as commonly used in gamelan 
.25::second => dur beat;

while (true) { // do the stuff in the brackets forever
    
    freq1 => bar.freq;   //set the bar's frequency to our first note
     1 => bar.noteOn;    // strike the bar 
    beat => now;  // elapse time
        
    freq2 => bar.freq;   // same here but second note
    1 => bar.noteOn;
    beat => now;
    
    freq3 => bar.freq;
    1 => bar.noteOn;
    beat => now;
    
    freq4 => bar.freq;  // and so on
    1 => bar.noteOn;
    beat => now;
    
    
    freq5 => bar.freq;
    1 => bar.noteOn;
    beat => now;
    
}            // here's the bottom of the loop

// 3. suggested exercises:
/*

1. Launch a bunch of instances of this program, try to get them to offset each other in interesting ways
  
  2.  add or subtract 12 to/from "baseNote" in setting some of the midi notes (move up or down an octove): 
    
    Std.mtof(baseNote+4+12) => float freq3;
    
 
 3. Move notes around---switch the first and third notes
  
    
4. change the timing --fiddle with beat (try dividing it in half or doubling it)
--change some of the references to "beat" to "beat/2" or "beat/4"
  
5. Change ModalBar to Rhodey or Mandolin or Saxofony
 
6. add reverb by changing the first line of code to read
 
ModalBar bar => NRev rev => dac;

control the amount of reverb with this line

0.2 => rev.mix; // the number can run from 0.0 to 1.0
 
7. add echo by replacing the first line with:
 
ModalBar bar => Echo e =>  NRev rev =>  dac;  // connect an instance of the ModalBar unit generator to the digital-audio converter
0.2 => rev.mix; // set reverb low to keep from smearing the echoes 
0.125::second => e.delay; // set echo time; try making this longer and shorter; you can also set it equal to beat or beat/2, say
0.9 => e.gain; //echo volume

 8. move it in the stereo field by adding panning (change the first line to read as follows, then add the second line)
 
ModalBar bar => Echo e =>  NRev rev =>  Pan2 pan => dac; 
  -1.0 => pan.pan; // hard left; 1 = hard right, in between gives you middle-ish positions
  
  9. choose a different preset for ModalBar
  
   0 => bar.preset;
  
         - Marimba = 0
         - Vibraphone = 1
         - Agogo = 2
         - Wood1 = 3
         - Reso = 4
         - Wood2 = 5
         - Beats = 6
         - Two Fixed = 7
         - Clump = 8
  
  10. Pick a random parameter and increase or decrease it until the program either fails or something really cool or awful happens


*/

// 4. References:

/*

http://chuck.cs.princeton.edu     download the interface, find tutorials and example code (examples are also available from the user interface under open/examples)

http://chuck.cs.princeton.edu/doc/program/ugen_full.html unit generator reference

https://www.kadenze.com/courses/introduction-to-programming-for-musicians-and-digital-artists/info     free online courese in coding in ChucK

https://www.amazon.com/Programming-Musicians-Digital-Artists-Creating/dp/1617291706/     excellent textbook on ChucK

http://booki.flossmanuals.net/chuck/   chuck FLOSS manual

https://toplap.org    algorithmic/live coding references/community/events

https://bit.ly/2FoDnT9    my youtube page with ChucK stuff

https://www.youtube.com/watch?v=S-T8kcSRLL0&t=3s   cool TED talk by the creator of ChucK
