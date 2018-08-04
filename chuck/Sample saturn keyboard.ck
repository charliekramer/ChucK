//sounds of saturn
// see https://www.techtimes.com/articles/232078/20180711/saturn-sings-an-eerie-cosmic-tune-to-enceladus-here-s-how-to-listen-to-it.htm
// credit: Tom Dowling
// modify for midi control

SndBuf saturn => NRev rev => Envelope e => PitShift pitch => Gain g => Pan2 p => dac;

.5 => rev.mix;

0.1 => g.gain;
;

me.dir(-1)+"chuck/audio/SoundsofSaturnClip.wav" => saturn.read;

MidiIn min;

1 => int port;

if (!min.open(port) )
{
    <<< "port not found ", port >>>;
    me.exit();
}

MidiMsg msg;

while (true)
{
    min => now;
    while ( min.recv(msg) ) {
        <<< msg.data1, msg.data2, msg.data3 >>>;
        if (msg.data1 == 144) {
            0=>saturn.pos;
            Std.mtof(msg.data2)/Std.mtof(60)*2 => pitch.shift;
            msg.data3/127.0=>saturn.gain;
            1=>e.keyOn;
            }
     }
}
