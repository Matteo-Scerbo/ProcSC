

(
 SynthDef(\s1,
	{
		arg freq,amp,pan;    // Number of the buffer to play
		var sig;
		sig = SinOsc.ar(freq,mul:amp);

		Out.ar(0, Pan2.ar(sig,pan));
 }).add;
)

// Create a network with the listener
// SuperCollider will listent to msgs at defined port and address
NetAddr("127.0.0.1",57120);

(
var synth1,synth2;
synth1 = Synth(\s1,[\freq, 440,\amp,0.5,\pan,-1]);
synth2 = Synth(\s1,[\freq, 880,\amp,0.5,\pan,1]);

OSCdef('OSCreceiver',
	{
		arg msg;

		x = msg[1];
		y = msg[2];

		x = (x-0.5)/0.5;

		postln("x: "+x+" - y: "+y);
		synth1.set(\amp,y,\pan,x);
		synth2.set(\amp,1-y,\pan,1-x);

	},
	"/pos");
)


//__________________________________



~song1 = Buffer.read(s,"/Users/MaX/Work/Didattica e Seminari/Computer Music/2016-2017/Part 5 - Music interaction/ex2_MixSquare/test2.wav");

~song2 = Buffer.read(s,"/Users/MaX/Work/Didattica e Seminari/Computer Music/2016-2017/Part 5 - Music interaction/ex2_MixSquare/test.wav");

(
 SynthDef(\song,
	{
		arg bufnum = 0,amp,pan;    // Number of the buffer to play
		var sig;

		sig = PlayBuf.ar(1, bufnum, 1, doneAction:0);

		Out.ar(0, Pan2.ar(sig*amp,pan));
 }).add;
)



NetAddr("127.0.0.1",57120);

(
var synth1,synth2;
synth1 = Synth(\song,[\amp,0.5,\pan,-1,\bufnum, ~song1.bufnum]);
synth2 = Synth(\song,[\amp,0.5,\pan,1,\bufnum, ~song2.bufnum]);

OSCdef('OSCreceiver',
	{
		arg msg;

		x = msg[1];
		y = msg[2];

		x = (x-0.5)/0.5;

		postln("x: "+x+" - y: "+y);

		synth1.set(\amp,y,\pan,x);
		synth2.set(\amp,1-y,\pan,1-x);

	},
	"/pos");
)

