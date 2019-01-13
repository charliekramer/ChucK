
MidiOut mout;
mout.open(2);

while(true)
{
    MidiMsg kick;
    MidiMsg cymb;
    MidiMsg snare;
    MidiMsg tom;
    
    
    0x90 => kick.data1;
    35 => kick.data2;
    127 => kick.data3;
    mout.send(kick);
    
     0x90 => cymb.data1;
    42 => cymb.data2;
    127 => cymb.data3;
    mout.send(cymb);

    .2::second => now;
    
    0x90 => kick.data1;
    36 => kick.data2;
    127 => kick.data3;
    mout.send(kick);

    .2::second => now;
/*    
    0x90 => msg.data1;
    38 => msg.data2;
    127 => msg.data3;
    mout.send(msg);

    .2::second => now; 
    
    0x90 => msg.data1;
    42 => msg.data2;
    127 => msg.data3;
    mout.send(msg);

    .2::second => now;
 */   
    
    
 /*   
    0x80 => msg.data1;
    60 => msg.data2;
    0 => msg.data3;
    mout.send(msg);
    
    1::second => now;
    */
}
