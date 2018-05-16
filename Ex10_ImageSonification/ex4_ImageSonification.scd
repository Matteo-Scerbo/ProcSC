

~song = Buffer.read(s,"/Users/MaX/Work/Didattica e Seminari/Computer Music/2016-2017/Part 5 - Music interaction/ex4_ImageSonification/test2.wav");

(
 SynthDef(\s1,
	{
		arg bufnum = 0, freqfilter = 10000;    // Number of the buffer to play
		var sig,imp;

		sig = PlayBuf.ar(1, bufnum, 1, doneAction:0);
		sig = BLowPass.ar(sig,freq:freqfilter, rq:1);

		Out.ar(0, Pan2.ar(sig,0));
 }).add;
)


// Dust
(
 SynthDef(\dust,
	{
		arg noiseIntensity =1, gainDust=1;
		var sig;

		sig = Crackle.ar(1.9, 0.005);
		sig = sig + HPF.ar(BrownNoise.ar(0.003*noiseIntensity/3),2000);
		sig = sig + LPF.ar(Dust.ar(1*noiseIntensity),600);
		sig = sig +  BPF.ar(0.8*Dust.ar(1*noiseIntensity),1000,0.5);

		sig = sig*gainDust;

		Out.ar(0, Pan2.ar(sig,0));
 }).add;
)



NetAddr("127.0.0.1",57120);

(
var song, effect;

song = Synth(\s1,[\bufnum, ~song.bufnum]);
effect = Synth(\dust,[\noiseIntensity, 1,\gainDust,1]); //1-10; 0-1

OSCdef('OSCreceiver',
	{
		arg msg;

		var hue, saturation, brightness;

		hue = msg[1];
		saturation = msg[2];
		brightness = msg[3];

		postln("hue: "+hue+" - saturation: "+saturation+" brightness :"+brightness);
		song.set(\freqfilter,(pow(brightness,2)*20000));
		effect.set(\noiseIntensity, (1-brightness)*10);
		effect.set(\gainDust, 1-brightness);

	},
	"/color");
)