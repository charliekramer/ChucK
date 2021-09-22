
10 => float gainSet;


10::minute => dur length;
2::minute => dur outro;

SndBuf bufL => Dyno dynL => LPF filtL => NRev revL => Echo echoL => Pan2 panL => dac;
SndBuf bufR => Dyno dynR => LPF filtR => NRev revR => Echo echoR => Pan2 panR => dac;

gainSet => bufL.gain => bufR.gain;

"/Users/charleskramer/Desktop/chuck/audio/voicemail-531.wav" => bufR.read => bufL.read;

1 => bufL.loop => bufR.loop;

4 => bufL.rate => float rateBase;

-bufL.rate() => bufR.rate;


5::second => echoL.max => echoL.delay;
.5 => echoL.mix => echoL.gain;
echoL => echoL;

5::second => echoR.max => echoR.delay;
.5 => echoR.mix => echoR.gain;
echoR => echoR;

Std.mtof(40) => filtL.freq => filtR.freq => float freqBase;
4 => filtL.Q => filtR.Q;

.5 => revL.mix => revR.mix => float revBase;

(1::second)/length => float freq; // one half freq of length

SinOsc LFO => blackhole;

freq => LFO.freq;

<<< "freq" , freq >>>;

now + length => time future;

while (now < future) {
    
    (1.1+LFO.last())*echoL.max()/2.2 => echoL.delay => echoR.delay;
    (1.1+LFO.last())*freqBase => filtL.freq => filtR.freq;
    
    (1+.5*LFO.last())*rateBase => bufL.rate;
    -bufL.rate() => bufR.rate;
    
    LFO.last() => panL.pan;
    -panL.pan() => panR.pan;
    
    1::samp => now;
    
    }
    
0 => bufL.loop => bufR.loop;
bufL.samples() => bufL.pos => bufR.pos;
    
outro => now;


