// HID
Hid hi;
HidMsg msg;

// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;


// infinite event loop
while( true )
{
    // wait for event
    hi => now;

    // get message
    while( hi.recv( msg ) )
    {
        // check
        if( msg.isButtonDown() )
        {
            spork~birb(Std.mtof(msg.which + 45.+12 ), -1);
            1::ms => now;
        }
       
    }
}

fun void birb(float freq,int direction) {
    1 => float delta;
    20 => int nStep;
    0 => int j;
    
    SinOsc sin => ADSR env => Echo echo => NRev rev => dac;
    (10::ms, 10::ms, 1, 20::ms) => env.set;
    3::second => echo.max;
    Std.rand2f(.25,.75)::second => echo.delay;
    .4 => echo.mix;
    .3 => echo.gain;
    echo => echo;
    .2 => rev.mix; 
    freq => sin.freq;
    1 => env.keyOn;
    while (j < nStep) {
        sin.freq()*(1+delta*direction/nStep) => sin.freq;
        if (sin.freq() > 10000) continue;
        10::ms => now;
        j++;
    }
    1 => env.keyOff;
    5::second => now;
    
}
    
