// midi controller version of impulse LFOspeed
// to do: program pads
.5*2 => float gainSet;
300::second => dur length;

Impulse imp => BPF filt => NRev rev => Dyno dyn => Gain master => dac;

MidiIn min;
MidiMsg msg; 

2 => int device;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

gainSet => master.gain; //*** 8

.2 => rev.mix; //***7

PulseOsc LFO => blackhole; // cool w/ sqrosc too, pulseosc;
.5 => LFO.width;

.2 => LFO.freq; //*5
.5 => LFO.gain; //*6

50::ms => dur beatBase => dur beat; //* 4
.01 => float minBeat; //minimum beat fraction *3
.01 => float minFreq; // 2

50 => imp.gain;
44 => filt.freq => float baseFreq;
20 => filt.Q; //*1

[22.,44.,150.,330.,440.,660.,800.,900.] @=> float notes[];

now + length => time future;

while (now < future) {
    
    while( min.recv(msg) )
    {
        
        if (msg.data1 == 144) {
            notes[msg.data2 - 36] => baseFreq;
            <<< "baseFreq", baseFreq >>>;
            }
            
        if (msg.data1 == 176) {
            if (msg.data2 == 1) {
           //     msg.data3/127.0 * 50.+.5 => filt.Q;
                msg.data3/127.0 * baseFreq+.5 => filt.Q;
             
                <<< "filt.Q", filt.Q() >>>;
            }
            if (msg.data2 == 2) {
                msg.data3/127.0 + .0001 => minFreq;
                <<< "minFreq", minFreq >>>;
            }
            if (msg.data2 == 3) {
                msg.data3/127.0 + .0001=> minBeat;  
                <<< "minBeat", minBeat >>>;
            }
            if (msg.data2 == 4) {
                (msg.data3/127.0+.01)*beatBase*2. => beat;
                <<< "beat", beat >>>;
            }
            if (msg.data2 == 5) {
                msg.data3/127.0 => LFO.gain;   
                <<< "LFO.gain", LFO.gain() >>>;
            }
            if (msg.data2 == 6) {
                msg.data3/127.0*20.+.01 => LFO.freq;
                 <<< "LFO.freq", LFO.freq() >>>;
            }
            if (msg.data2 == 7) {
                msg.data3/127.0 => rev.mix;
                <<< "rev.mix", rev.mix() >>>;
            }
            if (msg.data2 == 8) {
                msg.data3/127.0*gainSet => master.gain;
                 <<< "master.gain", master.gain() >>>;
            }
        }
        
    }
   
    
    1 => imp.next;
    ((1+LFO.last())*(1+LFO.last())+ minFreq )*baseFreq => filt.freq;
    ((1+LFO.last())*(1+LFO.last())+ minBeat )::beat =>  now;
}

15::second => now;
