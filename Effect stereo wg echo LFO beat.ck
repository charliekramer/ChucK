.5 => float gainSet;

BandedWG oscL => Echo echoL => dac.left;
BandedWG oscR => Echo echoR => dac.right;
SinOsc LFO => blackhole; // LFO beatlength

gainSet => oscL.gain => oscR.gain;

.05 => LFO.freq;

.25::second => dur beat;

10*beat => echoL.max => echoR.max;
1.5*beat => echoL.delay => echoR.delay;
.7 => echoL.gain => echoR.gain;
.7 => float echoMix => echoL.mix => echoR.mix;
echoL => echoL;
echoR => echoR;

.01 => float beatMin; //minimum beat fraction;

1 => int beatChoose; //choose beat LFO style;

1.0005 => float mod; //modify beat and freq each pass


while (true) {
    Math.fabs(LFO.last())*echoMix => echoL.mix => echoR.mix;
    1 => oscL.noteOn;
    if (beatChoose == 1) .5*(1+LFO.last()+.01)*beat => now;
    else if (beatChoose == 2) Math.fabs(LFO.last()+.01)*beat => now;
    1 => oscR.noteOn;
     if (beatChoose == 1) .5*(1+LFO.last()+.01)*beat => now;
    else if (beatChoose == 2) Math.fabs(LFO.last()+.01)*beat => now;
    
    beat*mod => beat;
    oscL.freq()/mod => oscL.freq;
    oscR.freq()/mod => oscR.freq;
    
    if (oscL.freq() < 20) me.exit();
    
    }