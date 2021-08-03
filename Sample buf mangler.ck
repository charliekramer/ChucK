SndBuf2 buf => Gain gain => blackhole;

Noise noise => blackhole;

1 => noise.gain;

SinOsc sinLFO => blackhole;
TriOsc triLFO => blackhole;
SqrOsc sqrLFO => blackhole;

25 => sinLFO.freq;
1.1*sinLFO.freq() => triLFO.freq;
1.1*triLFO.freq() => sqrLFO.freq;

"/Users/charleskramer/Desktop/chuck/audio/nari-lata-vela.wav" => buf.read;

"/Users/charleskramer/Desktop/chuck/audio/01_Red_Dress_vocal_splitted_by_lalalai.wav" => buf.read;

1=> buf.loop;

Impulse imp => PoleZero filt => Dyno dyn => Pan2 pan => dac;

0 => pan.pan;

.99 => filt.blockZero;

while (true) {
    
    Math.fabs(gain.last()) => imp.next;
    Math.log(Math.fabs(gain.last())) => imp.next; .1 => dyn.gain;
    Math.sqrt(Math.fabs(gain.last())) => imp.next;
    (1+noise.last())*gain.last() => imp.next;
    sinLFO.last()*gain.last() => imp.next;
    triLFO.last()*gain.last() => imp.next;
    sqrLFO.last()*gain.last() => imp.next;
    
    sinLFO.last()*triLFO.last()*sqrLFO.last()*gain.last() => imp.next;
    (1+sinLFO.last())*(1+triLFO.last())*(1+sqrLFO.last())*gain.last() => imp.next;
    
    1::samp => now;
    buf.rate()*.9999999 => buf.rate;
    
}
