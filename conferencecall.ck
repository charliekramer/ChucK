// http://conferencecall.biz
// by Zach 
// system input and output to ishowou
adc => Echo echo => NRev rev => dac;


.1 => rev.mix;
10::second => echo.max;
1.5::second => echo.delay;
.3 => echo.gain;
.0 => echo.mix;
echo => echo;

1::week => now;