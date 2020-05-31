/*
1. what is chuck
2. mini-audicle intro (can also run from command line
3. VM - start; look at running time
4. start; green + , appears in VM
5. remove, or click on VM
6. replace
7. clear machine

8. how audio works in chuck https://en.wikipedia.org/wiki/Sampling_(signal_processing)
*/

// this is the starter file for the ChucK clinic at Rhizome on 
// Sunday May 17.


SndBuf buf => dac; 
// create a sound buffer (SndBuf) called "buf"
// connect it ("=>" to the dac (digital audio converter)
// which is the thing that turns digital info (stored in your sound file)
// into sound

// now we need to put our file into the buffer

"/Users/charleskramer/Desktop/chuck/audio/breathe.wav" => buf.read;

// this reads my breathe.wav file into the buffer I created above 
// here we're using the ChucK operator ( => ) to assign a value to something
//  this works with wav and other formats listed here: 
// http://www.mega-nerd.com/libsndfile/#Features
// it doesn't work with MP3 files though.
// if you have an MP3 or other format,convert it to wav first.
// on a mac to copy this pathname, point at your file in the finder, 
// Control-Click on it, then hold down Option, and choose Copy [name of your file here] as Pathname

// next let's make sure it's wound to the beginning

0 => buf.pos; 

// set the position of the file to 0, the beginning of the file.
// the file is a list of data that is 44,100 x number of seconds long.

// now to actually hear the file, I need to move time forward
/*
5::second =>  now;

// it only plays once! let's make it loop

1 => buf.loop;

5::second => now;

//  slow it down

.7 => buf.rate;

5::second => now;

//  speed it up

1.5 => buf.rate;

5::second => now;

// backwards

-1 => buf.rate;

5::second => now;


// we can also advance it by one sample at a time

1 => buf.rate;

now + 5::second => time future;

while (now < future) {
    1::ms => now;
    buf.rate()*.9999 => buf.rate;
}


.2 => buf.rate;

<<< buf.samples(), buf.length() >>>;

while (true) {
    9900 => buf.pos;
    10000::samp => now;
    0 => buf.gain;
    10000::samp => now;
    1 => buf.gain;
}
*/

SinOsc sin => blackhole;
1 => buf.loop;

.2 => sin.freq;
1 => sin.gain;

while (true) {
    sin.last() => buf.rate;
    1::samp => now;
    
}
    
// other stuff
//panning
// LFO control
// limited start/end
// randomize start place
// synch (beat - (now % beat) => now);

/* references:

http://chuck.cs.princeton.edu     download the interface, find tutorials and example code (examples are also available from the user interface under open/examples)

http://chuck.cs.princeton.edu/doc/program/ugen_full.html unit generator reference

https://www.kadenze.com/courses/introduction-to-programming-for-musicians-and-digital-artists/info     free online courese in coding in ChucK

https://www.amazon.com/Programming-Musicians-Digital-Artists-Creating/dp/1617291706/     excellent textbook on ChucK

http://booki.flossmanuals.net/chuck/   chuck FLOSS manual

https://toplap.org    algorithmic/live coding references/community/events

https://www.northwoodselectro.com  my page with my live coding stuff

https://www.youtube.com/watch?v=S-T8kcSRLL0&t=3s   cool TED talk by the creator of ChucK
*/