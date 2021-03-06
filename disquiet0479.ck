SndBuf2 drive => Envelope envDrive => PitShift pitchDrive => Gain master => dac;
SndBuf2 rain => Envelope envRain => PitShift pitchRain => master => dac;
SndBuf2 radio => Envelope envRadio => PitShift pitchRadio => master => dac;

.2 => master.gain;
30::second => dur length;


"/Users/charleskramer/Desktop/chuck/audio/driving.wav" => drive.read;
"/Users/charleskramer/Desktop/chuck/audio/rain.wav" => rain.read;
"/Users/charleskramer/Desktop/chuck/audio/PB_radio.wav" => radio.read;
1 => float rainBase => rain.gain;
1 => float driveBase => drive.gain;
10*1 => float radioBase => radio.gain;

.125 => radio.rate => rain.rate => drive.rate;
.125::second*10 => dur beat;

1 => radio.loop;
1 => drive.loop;
1 => rain.loop;

1 => pitchRadio.mix => pitchRain.mix => pitchDrive.mix;

.4 => float pRain;
.5 => float pDrive;
.5 => float pRadio;


spork~LFOGains();

now + length => time future;

while (now < future) {
    
    Std.rand2(1,16)/8. => pitchRadio.shift;
    Std.rand2(1,16)/8. => pitchDrive.shift;
    Std.rand2(1,16)/8. => pitchRain.shift;
    
    if (Std.rand2f(0,1) > pRadio) 1 => envRadio.keyOn;
    if (Std.rand2f(0,1) > pDrive) 1 => envDrive.keyOn;
    if (Std.rand2f(0,1) > pRain) 1 => envRain.keyOn;
    Std.rand2(1,12)*beat => now;

}

fun void LFOGains() {
    SinOsc radioGain => blackhole;
    SinOsc driveGain => blackhole;
    SinOsc rainGain => blackhole;
    .1 => radioGain.freq;
    .15 => driveGain.freq;
    .125 => rainGain.freq;
    
    while (true) {
        (1+radioGain.last()*.5)*radioBase => radio.gain;   
        (1+driveGain.last()*.5)*driveBase => drive.gain;
        (1+rainGain.last()*.5)*rainBase => rain.gain;
        1::samp=> now;
        }
    
    }

