// https://attunedvibrations.com/free-healing-tones/

.5 => float gainSet;
3::minute => dur length;

[174.,285.,396.,417.,528.,639.,741.,852.,963.] @=> float tones[];

BandedWG osc1 => Echo echo1 => dac.left;
ModalBar osc2 => Echo echo2 => dac.right;
Echo echo3 => dac;

gainSet => osc1.gain => osc2.gain;

echo1 => Gain echoGain1 => echo2;
echo2 => Gain echoGain2 => echo1;

.5 => echoGain1.gain;
.5 => echoGain2.gain;

0 => int i;

3 => int interval;

1::second => dur beat;

1.5*beat => echo1.max => echo2.max;
1.5*beat => echo1.delay;
1.25*beat => echo2.delay;
.5 => echo1.mix => echo2.mix;

echo1 => echo3 => dac;

3*beat =>echo3.max;
1.25*1.5*beat => echo3.delay;
.5 => echo3.gain;
.5 => echo3.mix;
echo3 => echo3;

1 => int dI;
0 => int count;
1 => float onOne;
1 => float onTwo;
16 => int nBars;
0 => int onRand;


now + length => time future;

while (now < future) {
    tones[i % tones.cap()] => osc1.freq;
    tones[(i+interval) % tones.cap()] => osc2.freq;
    if (onRand == 1) {
        Std.rand2f(0,1) => onOne;
        Std.rand2f(0,1) => onTwo;
    }
    onOne => osc1.noteOn;
    onTwo => osc2.noteOn;
    beat => now;
    i + dI => i;
    count ++;
    if ((count % nBars) == 0 ) {
        Std.rand2(1,tones.cap()-2) => interval;
        Std.rand2(1,tones.cap()-2) => dI;
    <<< "interval, ", interval, "dI", dI, "onOne,", onOne, " onTwo", onTwo, "onRand, ", onRand >>>;
      }
    if ((count == (2*nBars)) ) {
        Std.rand2(1,tones.cap()-2) => interval;
        Std.rand2(1,tones.cap()-2) => dI;
        0 => onTwo;
     <<< "interval, ", interval, "dI", dI, "onOne,", onOne, " onTwo", onTwo, "onRand, ", onRand >>>;
     }
    if ((count == (3*nBars))) {
        Std.rand2(1,tones.cap()-2) => interval;
        Std.rand2(1,tones.cap()-2) => dI;
        1 => onTwo;
        0 => onOne;
    <<< "interval, ", interval, "dI", dI, "onOne,", onOne, " onTwo", onTwo, "onRand, ", onRand >>>;
    }
    if ((count == (4*nBars))) {
        Std.rand2(1,tones.cap()-2) => interval;
        Std.rand2(1,tones.cap()-2) => dI;
        1 => onRand;
     <<< "interval, ", interval, "dI", dI, "onOne,", onOne, " onTwo", onTwo, "onRand, ", onRand >>>;
     }
    if ((count == (5*nBars))) {
        Std.rand2(1,tones.cap()-2) => interval;
        Std.rand2(1,tones.cap()-2) => dI;
        0 => onRand;
        1 => onOne;
        1 => onTwo;
        <<< "interval, ", interval, "dI", dI, "onOne,", onOne, " onTwo", onTwo, "onRand, ", onRand >>>;
    }
}

<<< "solfeggio ending" >>>;

15::second => now;
