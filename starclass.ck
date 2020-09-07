// create "starfield" of oscs differentiated by x (pan) and y (pitch)
// move away from 'origin' by polar coord (increase r)
// send to processing via osc
// need scaling on pitch vs pan (define max)(create mapping function)
// mapping doesn't work--output (yv vars) don't move; can't pass function calls?

.1 => float gainSet;
15 => int nStar;
57. => float midiBase;
midiBase + 12. => float midiBaseMax; // these don't work
midiBase - 12. => float midiBaseMin; // need to fix mapping

.5 => float dR;
.1 => float r; //radius for calculations
.4 => float rMax; 
.01 => float rMin;
.1 => float rDelta; //r + dR*Std.rand2f(0,rDelta)*(rmax-r) => r;
.001 => float tol; //tolerance for reset

.1 => float LFOGainSet; // gain for gainLFOs;
2 => float LFOFreqSet; // frequency for gainLFOs;

// osc setup;
"localhost" => string hostname;
6449 => int port;
OscOut xmit;
xmit.dest( hostname, port );
/*
 // start the message...
    xmit.start( "/sndbuf/buf/rate" );
    
    // add float arg
    Math.random2f( .5, 2.0 ) => float temp => xmit.add;
    
    // send
    xmit.send();
    <<< "sent (via OSC):", temp >>>;
*/

Star star;
spork~LFOGain();

1::second => now;

while (true) {
    star.starMove();
    //star.printParms();
    star.sendOsc();
    .1::second => now;
    if ( (rMax -r) < tol || (r - rMin) < tol ) star.reset();
}

class Star {
    
    SinOsc osc[nStar];
    Pan2 pan[nStar];
    float theta[nStar];
    
    for (0 => int i; i < nStar; i++) {
        Std.rand2f(0, 2*pi) => theta[i];
        gainSet => osc[i].gain;
        Std.mtof(midiBase)*(1+r*Math.sin(theta[i])) => osc[i].freq;
        r*Math.cos(theta[i]) => pan[i].pan;
        osc[i] => pan[i] => dac;
    }
    
    fun void starMove() {
        // migrate away from origin
        
        if (dR> 0) r + dR*Std.rand2f(0,rDelta)*(rMax-r) => r;
        else  r + dR*Std.rand2f(0,rDelta)*(r-rMin) => r;
        
       // <<< "r , dR, rmax, rMin" , r, rMax, rMin >>>;
        for (0 => int i; i < nStar; i++) {
            Std.mtof(midiBase)*(1+r*Math.sin(theta[i])) => osc[i].freq;
            r*Math.cos(theta[i]) => pan[i].pan;    
        }
    }
    fun void volSet(float vol, int i) {
        vol => osc[i].gain;
    }  
    
    fun void printParms() {
        <<< "r , rmax, rMin" , r, rMax, rMin >>>;
        for (0 => int i; i < nStar; i++) {
           <<< "i, freq, pan, theta", osc[i].freq(), pan[i].pan(), theta[i] >>>;
        }
    }
    
    
    fun void sendOsc() {
        xmit.start("/star/gains");
        for (0 => int i; i < nStar; i++) {
            osc[i].gain() => xmit.add;
            //<<< "sending" , i, osc[i].gain() >>>;
        }
        xmit.send();
        
        xmit.start("/star/pans");
        for (0 => int i; i < nStar; i++) {
            pan[i].pan() => xmit.add;
        }
        xmit.send();
        
        xmit.start("/star/freqs");
        for (0 => int i; i < nStar; i++) {
            osc[i].freq() => xmit.add;
        }
        xmit.send();
       
    }
    
    fun void reset() {
        //move back to /away from origin
        //<<< "reset" >>>;
        .25::second => now;
        -1*dR => dR;
        if ((r - rMin) < tol) {
            
            for (0 => int i; i < nStar; i++) {
                Std.rand2f(0, 2*pi) => theta[i];
                Std.mtof(midiBase)*(1+r*Math.sin(theta[i])) => osc[i].freq;
                r*Math.cos(theta[i]) => pan[i].pan;
            }
        }
    }
        
    

}

fun float map (float xin, float xmin, float xmax, float ymin, float ymax) {
    float a, b;
    (ymax - ymin)/(xmax - xmin) => b;
    ymax - b*xmax => a;
    //<<< "a, b", a, b >>>;
    return a + b*xin;
}

fun void LFOGain() {
    SinOsc gainLFO[nStar];
    for (0 => int i; i < nStar; i++) {
        gainLFO[i] => blackhole;
        LFOFreqSet*(Std.rand2f(.9,1.1)) => gainLFO[i].freq;
        LFOGainSet*(Std.rand2f(.9,1.1)) => gainLFO[i].gain;
    }
    while (true) {
        for (0 => int i; i < nStar; i++) {    
            star.volSet((1+gainLFO[i].last())*gainSet,i);
        }
        1::samp => now;
    }
    
}
   
        
    