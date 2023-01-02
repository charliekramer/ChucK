SndBuf2 buf0 => LPF filt0 => Gain gain0 => dac;

.3 => gain0.gain;

gain0 => Echo echoL => PitShift pitchL => Pan2 panL => dac;
gain0 => Echo echoR => PitShift pitchR => Pan2 panR => dac;

Std.mtof(52+36) => filt0.freq;
1 => filt0.Q;


300::ms => echoL.max => echoL.delay;
1 => echoL.mix => echoL.gain;
1.5 => pitchL.shift;
1 => pitchL.mix;
.5 => panL.pan;

600::ms => echoR.max => echoR.delay;
1 => echoR.mix => echoR.gain;
Std.mtof(57+4)/Std.mtof(57) => pitchR.shift;
1 => pitchR.mix;
-panR.pan() => panL.pan;

"/Users/charleskramer/Desktop/chuck/audio/dark_star_edit_015_25speed.wav" => buf0.read;
//"/Users/charleskramer/Desktop/chuck/audio/dark_star_edit_015speed.wav" => buf0.read;

1::hour => now;