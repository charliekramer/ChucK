
Blit blit => BiQuad f => NRev rev => Gain master => dac;
BlitSquare sqr => f => rev=>  master => dac;
BlitSaw saw => f => rev =>  master => dac;

.01 => master.gain;

SinOsc pLFO => blackhole; // modulate pole freq
SinOsc zLFO => blackhole; // modulate zero freq
SinOsc rLFO => blackhole; // modulate reverb level

// interesting to modulate reverb lfo at audio frequencies like 220

.05 => rLFO.freq;
.8 => float revMax;

.1 => pLFO.freq; // 100 and 10 are both interesting
pLFO.freq()*1.1 => zLFO.freq; // slightly different for fun beating/cancellation effects

.2 => saw.gain => blit.gain => sqr.gain;

44 => int midiBase;

Std.mtof(midiBase) => blit.freq;
Std.mtof(midiBase+4) => sqr.freq;
Std.mtof(midiBase+7) => saw.freq;

0.9 => f.prad;
1000.0 => f.pfreq;
0.9 => f.zrad;
1000.0 => f.zfreq;

1000 => float freqBase;

60./120.*2. => float beatSec;
beatSec::second => dur beat;

1 => saw.harmonics;
4 => blit.harmonics;
2 => sqr.harmonics;

1 => int delta;

while (true) {
	
	revMax*rLFO.last() => rev.mix;
	(1.5+pLFO.last())*freqBase => f.pfreq;
	(1.5+zLFO.last())*freqBase => f.zfreq;
	1::samp => now;
	if (now % beat == 0::second) { // problem only works for even division
		blit.harmonics()+delta => blit.harmonics;
		sqr.harmonics()+delta => sqr.harmonics;
		saw.harmonics()+delta => saw.harmonics;
		if (saw.harmonics() == 1 || saw.harmonics() == 18) delta*-1 => delta;
		<<< "chg", saw.harmonics() >>>;
	}
	
}

