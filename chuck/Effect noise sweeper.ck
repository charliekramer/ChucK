.125::second => now;
0.5::second => dur d1;
d1 - (now % d1) => now;


Noise n => LPF l => Envelope e => Chorus p => dac;

200 => float basefreq;
basefreq=> l.freq;
200. => float freqdelta;

.05::second => dur d;



while (true) {
    
 1 => e.keyOn;
 d => now;
 l.freq()+freqdelta => l.freq;
 1 => e.keyOff;
 d => now;
 if (l.freq() > 5000) -1.*freqdelta => freqdelta;
  if (l.freq() < basefreq) -1.*freqdelta => freqdelta;
}