// sample wrecked through power/min function LFOd and LFOd time
// sweeping sound
// timed

.1 => float gainSet;

SndBuf buf1 =>  blackhole;
10 => buf1.gain;

"/Users/charleskramer/Desktop/chuck/audio/nixon_humiliate.wav" => buf1.read;
1 => buf1.loop;


SndBuf buf2 =>  blackhole;

.1 => buf2.gain;
"/Users/charleskramer/Desktop/chuck/audio/reach.wav" => buf2.read;
1 => buf2.loop;

SinOsc LFO1 => blackhole; // # of samples => now;
SinOsc LFO2 => blackhole; //# of samples => now

10 => LFO1.gain;
10 => LFO2.gain;
.1 => LFO1.freq;
.2 => LFO2.freq;

SinOsc LFO3 => blackhole; // min of power function 
SinOsc LFO4 => blackhole; // min of power function

1 => LFO3.gain;
11 => LFO4.gain;

.05 => LFO3.freq; // multiply freqs by large # (100-1000) for cut effects
.07 => LFO4.freq;

SinOsc LFO5 => blackhole; // filter cutoff
SinOsc LFO6 => blackhole; // filter cutoff

.5 => LFO5.gain;
.5 => LFO6.gain;

.15 => LFO5.freq;
.22 => LFO6.freq;



Impulse imp => LPF filt => Gain gain => NRev rev => Dyno dyn => dac;

.1 => rev.mix;

gainSet => gain.gain;

300 => float filtFreq => filt.freq;
2 => filt.Q;

now + 24::second => time future;



while (now < future) {
   
   //((Std.ftoi(buf1.last()*10000000)) | (Std.ftoi(buf1.last()*10000000)))/10000000 => imp.next;
   Math.min(Math.pow(.1+buf1.last(),buf2.last())*.1,1*(1+LFO3.last())) => imp.next;
   (10+LFO1.last())*Std.rand2(1,2)::samp => now;
    Math.min(Math.pow(.1+buf2.last(),buf1.last())*.1,1*(1+LFO4.last())) => imp.next;
   (10+LFO2.last())*Std.rand2(1,2)::samp => now;
   (1 + LFO5.last() + LFO6.last())*filtFreq => filt.freq;
  
    }
    
    10::second => now;