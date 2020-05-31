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

5::second =>  now;

// if you hear five seconds of your file, you're ready!
// if you can't, feel free to email me at taos.points@gmail.com

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