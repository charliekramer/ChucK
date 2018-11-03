// noise copter
.125::second => now;
0.5::second => dur d1;
d1 - (now % d1) => now;


Noise n => LPF l => Envelope e => Chorus p => Pan2 pan => dac;

200 => float basefreq;
basefreq=> l.freq;
200. => float freqdelta;

.05::second => dur d;

0.2 => n.gain;

-.8 => pan.pan;
.01 => float panDelta;


while (true) {
    
 1 => e.keyOn;
 d => now;
 l.freq()+freqdelta => l.freq;
 1 => e.keyOff;
 d => now;
 pan.pan()+panDelta => pan.pan;
 if (l.freq() > 5000 || l.freq() < basefreq ) -1.*freqdelta => freqdelta;
 if (pan.pan() > .9 || pan.pan() < -.9 ) panDelta*-1 => panDelta;
}