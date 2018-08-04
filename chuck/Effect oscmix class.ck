
class oscMixSinClass
{
    
    4 => int nosc;
    5. => float d;
   440. => float currfreq;
    .1 => float ti;
    0 => int random;
    
    public void nosc_set (int n)
    { n => nosc; }
    public void d_set (float dd)
    { dd => d; }
    public void cf_set (float ccf)
    { ccf => currfreq; }
    public void ti_set (float tti)
    { tti => ti; }
    public void rand_set (int rand)
    { rand => random; }
    
    <<< "in function: currfreq",currfreq >>>;
    
    <<< "in function: currfreq",currfreq >>>;

    
 //   fun void oscmixSin(int nosc, float d, float currfreq, float ti, int random)
      fun void oscmixSin()

    { 
        
        SinOsc s[nosc];
       
        
        for (0=>int j; j<s.cap(); j++)
        {
            s[j]=>NRev r => Echo e => dac;
            0.5=>r.gain;
            0.05=>e.mix;
            10.0/s.cap()=>s[j].gain;    
        }

      
        
 //      while (true)
  //      {
            if (random == 1) 
            {   Std.rand2f(.1,3.7)=>d;
            Std.rand2f(.1,1.3)=>ti;
            }
        
        for (1=>int i; i < s.cap(); i++)
            {
            currfreq + d*i => s[i].freq;  
            //  <<< i, s[i].freq()>>>; 
            }
        
  //      ti::second=> now;
        
  //      }
        


    
    }
    
}



oscMixSinClass s;

<<< "0. currfreq", s.currfreq >>>;

600 => s.currfreq;
.1 => s.d;
20=>s.nosc;


<<< "1. currfreq", s.currfreq >>>;
s.oscmixSin();
5::second=> now;
Std.rand2(60,90)=>s.currfreq;
s.oscmixSin();
2::second=>now;

<<< "2. currfreq", s.currfreq >>>;


